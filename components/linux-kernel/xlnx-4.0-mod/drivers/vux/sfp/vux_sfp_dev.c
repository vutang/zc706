/*
* @Author: vutang
* @Date:   2018-10-16 08:15:15
* @Last Modified by:   vutang
* @Last Modified time: 2018-10-20 14:37:53
*/

#include <linux/cdev.h>
#include <linux/types.h>
#include <linux/device.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/notifier.h>

#include <linux/slab.h>
#include <linux/debugfs.h>
#include <linux/i2c.h>

#include "vux_sfp_core.h"

#define SFP_MAJOR 		384
#define SFP_MAX_MINORS 	4

typedef struct{
	struct class *cl;

	int dev_active_list[SFP_MAX_MINORS];
	/*Define at linux/cdev.h, struct cdev represent a character device
	within the kernel; struct cdev hold a pointer pointing to struct file_operations*/
	struct cdev cdev[SFP_MAX_MINORS];
	/*Define in linux/types.h (just a 32 bit number), is used to hold device number,
	both the major and minor parts. Refer MAJOR, MINOR & MKDEV in kdev_t.h for more info*/
	dev_t dev[SFP_MAX_MINORS];

	sfp_drvdata_t *sfpdev_drvdata_list[SFP_MAX_MINORS];
} sfpdev_priv_t;

sfpdev_priv_t *sfpdev_priv;

/*Debug file dir*/
static struct dentry *dir = 0;

static int sfpdev_open(struct inode *inode, struct file *file) {
	unsigned int minor = iminor(inode);
	unsigned int major = imajor(inode);

	printk("sfpdev_open {major, minor}: {%d, %d}\n", major, minor);

	file->private_data = sfpdev_priv->sfpdev_drvdata_list[minor];
	return 0;
}

static int sfpdev_release(struct inode *inode, struct file *file) {
	unsigned int minor = iminor(inode);
	unsigned int major = imajor(inode);

	printk("sfpdev_open: {major, minor}: {%d, %d}\n", major, minor);

	file->private_data = NULL;
	return 0;
}

/*arg can be a pointer to a user space buffer or a usigned long variable*/
static long sfpdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, \
	unsigned long arg) {
	unsigned int minor = iminor(inode);
	unsigned int major = imajor(inode);
	printk("sfpdev_ioctl: {major, minor}: {%d, %d}\n", major, minor);
	/*
	unsigned long copy_to_user(void __user *to, const void *from, unsigned long n);
	unsigned long copy_from_user(void *to, const void __user *from, unsigned long n)
	*/
	return 0;
}

const static struct file_operations sfp_fops = {
	.open = sfpdev_open,
	.release = sfpdev_release,
	.unlocked_ioctl = sfpdev_ioctl,
};

/*For test SYSFS Device Attributes
https://www.kernel.org/doc/Documentation/filesystems/sysfs.txt
*/
static ssize_t sfpdev_show_vendor(struct device *dev, struct device_attribute *attr,
			char *buf) {
	int ret;
	ret = sprintf(buf, "ViettelSFP%d", MINOR(dev->devt));
	return ret;
}

/*Permision bit
https://www.gnu.org/software/libc/manual/html_node/Permission-Bits.html
*/
static DEVICE_ATTR(vendor, S_IRUGO, sfpdev_show_vendor, NULL);

static ssize_t sfpdev_show_temp(struct device *dev, struct device_attribute *attr,
			char *buf) {
	int ret;
	int temperature;
	unsigned char tmp[2];
	sfp_drvdata_t *drvdata;
	drvdata = sfpdev_priv->sfpdev_drvdata_list[MINOR(dev->devt)];
	if (!drvdata) {
		printk("Get drvdata failed\n");
		goto ret_error;
	}

	/*Read MSB Temperature*/
	tmp[1] = i2c_smbus_read_byte_data(drvdata->client, 96);
	if (tmp[1] < 0) {
		printk("Read MSB Temperature failed\n");
		goto ret_error;
	}
	/*Read LSB Temperature*/
	tmp[0] = i2c_smbus_read_byte_data(drvdata->client, 97);
	if (tmp[0] < 0) {
		printk("Read LSB Temperature failed\n");
		goto ret_error;
	}

	// temperature = (((int) tmp[1] * 256) + (int) tmp[0]) / 256;
	printk("Temperature: %d.%02d\n", tmp[1], (int) tmp[0] * 100 / 256);
	ret = sprintf(buf, "%d %d", tmp[1], tmp[0]);
	return ret;

ret_error:
	temperature = -1;
	ret = sprintf(buf, "%d", -1);	
	return ret;
}
static DEVICE_ATTR(temperature, S_IRUGO, sfpdev_show_temp, NULL);


/*For Debugfs*/
static int  sfpdev_debugfs_open (struct inode *inode, struct file *file) {
	printk("Open sfpdev_debugfs file\n");
	return 0;
}
static const struct file_operations sfpdev_debugfs_fops = {
	.open = sfpdev_debugfs_open,
	.owner = THIS_MODULE,
};


/*Create Device and File Device*/
static int sfpdev_create_device(sfp_drvdata_t *sfp_drvdata) {
	struct device *dev;
	int id = sfp_drvdata->id;
	int ret;
	/*Make Major/Minor number*/
	sfpdev_priv->dev[id] = MKDEV(SFP_MAJOR, id);

	/*Get driver data*/
	sfpdev_priv->sfpdev_drvdata_list[id] = sfp_drvdata;


	/*Create device*/
	/*Device: a physical device that is attached to a bus, 
	but in this driver, dev is not really physical device

	After calling device_create, a file will appear in /dev/ dir
	if creating procedure is success*/
	dev = device_create(sfpdev_priv->cl, NULL, sfpdev_priv->dev[id], \
		NULL, "sfp-%d", id);
	if (dev == NULL){
		printk("device_create fail");
		return -1;
	}
	printk("device_create dev: %s\n", dev_name(dev));

	/*create Sysfs file*/
	if (id == 0) {
		ret = device_create_file(dev, &dev_attr_vendor);
		if (ret < 0) 
			printk("failed to create write /sys endpoint - continuing without\n");
	}

	if (id == 1) {
		ret = device_create_file(dev, &dev_attr_temperature);
		if (ret < 0) 
			printk("failed to create write /sys endpoint - continuing without\n");
	}

	/*create debugfs file*/
	if (dir) {
		printk("Create debugfs file\n");
		/*An file named sfpdev_debugfs is create in dir*/
		debugfs_create_file("sfpdev_debugfs", S_IRUGO, dir, NULL, &sfpdev_debugfs_fops);
	}

	/*Add Char Dev to system*/
	cdev_init(&sfpdev_priv->cdev[id], &sfp_fops);
	cdev_add(&sfpdev_priv->cdev[id], sfpdev_priv->dev[id], SFP_MAX_MINORS);

	sfpdev_priv->dev_active_list[id] = 1;
	return 0;
}

/*Receive Create/Delete Device Request from drv*/
static int sfpdev_notifier_call(struct notifier_block *nb, unsigned long action,
			 void *data) {

	sfp_drvdata_t *sfp_drvdata = (sfp_drvdata_t *) data;
	switch(action) {
		case BUS_NOTIFY_ADD_DEVICE:
			printk("Request add device id: %d\n", sfp_drvdata->id);
			sfpdev_create_device(sfp_drvdata);
		default:
			break;
	}
	return 0;
}

static struct notifier_block sfpdev_notifier_nb = {
	.notifier_call = sfpdev_notifier_call,
};

static int __init sfpdev_init(void){
	int ret, i; 
	
	sfpdev_priv = (sfpdev_priv_t *) kzalloc(&sfpdev_priv->dev, GFP_KERNEL);
	if (!sfpdev_priv) {
		printk("Allocate sfpdev_priv fail");
		return -ENOMEM;
	}

	/*Mark empty for all device room*/
	for (i = 0; i < SFP_MAX_MINORS; i++) 
		sfpdev_priv->dev_active_list[i] = 0;

	ret = register_chrdev_region(MKDEV(SFP_MAJOR, 0), SFP_MAX_MINORS,
                                      "sfp_chrdev");
	if (ret != 0) {
		printk("Error in register_chrdev_region");
		return ret;
	}

	/*Define at linux/device.h, register a class of device driver*/
	if ((sfpdev_priv->cl = class_create(THIS_MODULE, "sfp_chardrv")) == NULL) {
		printk("class_create fail");
		return -1;
	}

	/*Register notifier*/
	sfp_register_notify(&sfpdev_notifier_nb);

	/*Create debug dentry*/
	/*CONFIG_DEBUG_FS in kernel configuration have to set to "y"
	This function will create a dir in /sys/kernel/debug/ named "sfpdev"
	*/
	dir = debugfs_create_dir("sfpdev", 0);
	if (!dir) 
		printk("failed to create debug dir\n");
	return 0;
}

static void __exit sfpdev_exit(void){
	int i;
	if (!sfpdev_priv)
		return;
	for (i = 0; i < SFP_MAX_MINORS; i++) {
		if (sfpdev_priv->dev_active_list[i]) {
			printk("cdev_del {%d, %d}\n", MAJOR(sfpdev_priv->dev[i]), \
					MINOR(sfpdev_priv->dev[i]));
			cdev_del(&sfpdev_priv->cdev[i]); 
			device_destroy(sfpdev_priv->cl, sfpdev_priv->dev[i]);
		}
	}

	if (dir)
		debugfs_remove_recursive(dir);
	unregister_chrdev_region(MKDEV(SFP_MAJOR, 0), SFP_MAX_MINORS);
	kfree(sfpdev_priv);
}

module_init(sfpdev_init);
module_exit(sfpdev_exit);

MODULE_AUTHOR("VUX");
MODULE_DESCRIPTION("SFP Char Device");
MODULE_LICENSE("GPL");