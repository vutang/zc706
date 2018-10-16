/*
* @Author: vutang
* @Date:   2018-10-16 08:15:15
* @Last Modified by:   vutang
* @Last Modified time: 2018-10-16 09:30:26
*/

#include <linux/cdev.h>
#include <linux/types.h>
#include <linux/device.h>
#include <linux/module.h>
#include <linux/fs.h>

#include <linux/slab.h>

#define SFP_MAX_DEVS 1

typedef struct{
	/*Define at linux/cdev.h, struct cdev represent a character device
	within the kernel; struct cdev hold a pointer pointing to struct file_operations*/
	struct cdev cdev;
	/*Define in linux/types.h (just a 32 bit number), is used to hold device number,
	both the major and minor parts. Refer MAJOR, MINOR & MKDEV in kdev_t.h for more info*/
	dev_t dev;
	struct class *cl
} sfpdev_priv_t;

sfpdev_priv_t *sfpdev_priv;

const static struct file_operations sfp_fops = {
	// .open = sfpdev_open,
	// .release = sfpdev_release,
	// .unlocked_ioctl = plipdev_ioctl,
};

static int __init sfpdev_init(void){
	int ret;

	sfpdev_priv = (sfpdev_priv_t *) kzalloc(&sfpdev_priv->dev, GFP_KERNEL);
	if (!sfpdev_priv) {
		printk("Allocate sfpdev_priv fail");
		return -ENOMEM;
	}

	/*A character file is associated with many device (represent by device number dev_t)
	Define in linux/fs.h
	int alloc_chrdev_region(dev_t *dev, unsigned int firstminor,
	unsigned int count, char *name);
		- dev_t *dev: output-only, hold the first number of allocated range
		- fistminor: requested first minor
		- count: total number of contiguous device numbers that are requesting
		- name: name of device that should be associated
	*/
	ret = alloc_chrdev_region(&sfpdev_priv->dev, 0, SFP_MAX_DEVS, "sfpdev");
	if (ret < 0)
		return ret;

	/*Define at linux/device.h, register a class of device driver*/
	if ((sfpdev_priv->cl = class_create(THIS_MODULE, "chardrv")) == NULL) {
		printk("class_create fail");
		goto unregister_chrdev_region_;
	}

	if (device_create(sfpdev_priv->cl, NULL, sfpdev_priv->dev, \
		NULL, "sfp") == NULL) {
		printk("device_create fail");
		goto class_destroy_;
	}

	cdev_init(&sfpdev_priv->cdev, &sfp_fops);
	cdev_add(&sfpdev_priv->cdev, sfpdev_priv->dev, SFP_MAX_DEVS);
	return 0;
class_destroy_:
	class_destroy(sfpdev_priv->cl);
unregister_chrdev_region_:
	unregister_chrdev_region(sfpdev_priv->dev, 1);
	return -1;
}

static void __exit sfpdev_exit(void){
	if (!sfpdev_priv)
		return;
	unregister_chrdev_region(sfpdev_priv->dev, SFP_MAX_DEVS);
	kfree(sfpdev_priv);
}

module_init(sfpdev_init);
module_exit(sfpdev_exit);

MODULE_AUTHOR("VUX");
MODULE_DESCRIPTION("SFP Char Device");
MODULE_LICENSE("GPL");