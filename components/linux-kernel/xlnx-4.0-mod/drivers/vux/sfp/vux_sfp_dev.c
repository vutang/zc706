/*
* @Author: vutang
* @Date:   2018-10-16 08:15:15
* @Last Modified by:   vutang
* @Last Modified time: 2018-10-19 17:36:06
*/

#include <linux/cdev.h>
#include <linux/types.h>
#include <linux/device.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/notifier.h>

#include <linux/slab.h>
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

/*Create Device and File Device*/
static int sfpdev_create_device(sfp_drvdata_t *sfp_drvdata) {
	struct device *dev;
	int id = sfp_drvdata->id;
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
	
	printk("Create dev: %s\n", dev_name(dev));

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
	if ((sfpdev_priv->cl = class_create(THIS_MODULE, "chardrv")) == NULL) {
		printk("class_create fail");
		return -1;
	}

	/*Register notifier*/
	sfp_register_notify(&sfpdev_notifier_nb);
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

	unregister_chrdev_region(MKDEV(SFP_MAJOR, 0), SFP_MAX_MINORS);
	kfree(sfpdev_priv);
}

module_init(sfpdev_init);
module_exit(sfpdev_exit);

MODULE_AUTHOR("VUX");
MODULE_DESCRIPTION("SFP Char Device");
MODULE_LICENSE("GPL");