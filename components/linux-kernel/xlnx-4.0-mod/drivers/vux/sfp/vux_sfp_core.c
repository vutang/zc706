/*
* @Author: vutang
* @Date:   2018-10-15 17:50:54
* @Last Modified by:   vutang
* @Last Modified time: 2018-10-18 11:39:25
*/

#include <linux/module.h>
#include <linux/list.h>
#include <linux/notifier.h>
#include <linux/device.h>

#include "vux_sfp_core.h"

typedef struct {
	struct blocking_notifier_head sfp_notifier_list;
} vux_sfp_core_priv_t;

/*General object*/
vux_sfp_core_priv_t sfp_core_priv;

/*Support register a notifier block*/
void sfp_register_notify(struct notifier_block *nb) {
	printk("Register notify\n");
	blocking_notifier_chain_register(&sfp_core_priv.sfp_notifier_list, nb);
}
EXPORT_SYMBOL_GPL(sfp_register_notify);

/*Use for add device, this function will notify vux_sfp_dev to create a
character file*/
void sfp_add_device(sfp_drvdata_t *sfp_drvdata) {
	blocking_notifier_call_chain(&sfp_core_priv.sfp_notifier_list, BUS_NOTIFY_ADD_DEVICE, \
		sfp_drvdata);
}
EXPORT_SYMBOL_GPL(sfp_add_device);

static int __init sfp_core_init(void) {
	printk("Init notifier head\n");

	/*Init a notifier list*/
	BLOCKING_INIT_NOTIFIER_HEAD(&sfp_core_priv.sfp_notifier_list);

	return 0;
}

static void __exit sfp_core_exit(void) { 
	return 0;
}

module_init(sfp_core_init);
module_exit(sfp_core_exit);


MODULE_AUTHOR("VUX");
MODULE_DESCRIPTION("Device Driver Practice");
MODULE_LICENSE("GPL");