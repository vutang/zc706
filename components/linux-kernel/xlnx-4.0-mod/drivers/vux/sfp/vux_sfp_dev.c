/*
* @Author: vutang
* @Date:   2018-10-16 08:15:15
* @Last Modified by:   vutang
* @Last Modified time: 2018-10-18 11:58:45
*/

#include <linux/cdev.h>
#include <linux/types.h>
#include <linux/device.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/notifier.h>

#include <linux/slab.h>
#include "vux_sfp_core.h"

#define SFP_MAJOR 384

static int sfpdev_notifier_call(struct notifier_block *nb, unsigned long action,
			 void *data) {

	sfp_drvdata_t *sfp_drvdata = (sfp_drvdata_t *) data;
	switch(action) {
		case BUS_NOTIFY_ADD_DEVICE:
			printk("Request add device id: %d\n", sfp_drvdata->id);
		default:
			break;
	}
	return 0;
}

static struct notifier_block sfpdev_notifier_nb = {
	.notifier_call = sfpdev_notifier_call,
};

const static struct file_operations sfp_fops = {
};

static int __init sfpdev_init(void){
	int ret; 
		
	ret = register_chrdev();

	/*Register notifier*/
	sfp_register_notify(&sfpdev_notifier_nb);
	return 0;
}

static void __exit sfpdev_exit(void){
}

module_init(sfpdev_init);
module_exit(sfpdev_exit);

MODULE_AUTHOR("VUX");
MODULE_DESCRIPTION("SFP Char Device");
MODULE_LICENSE("GPL");