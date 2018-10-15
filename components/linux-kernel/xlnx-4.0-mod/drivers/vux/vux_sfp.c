/*
* @Author: vutang
* @Date:   2018-10-15 17:50:54
* @Last Modified by:   vutang
* @Last Modified time: 2018-10-15 18:32:04
*/

#include <linux/module.h>
#include <linux/i2c.h>

static int sfp_probe(struct i2c_client *client,
			 const struct i2c_device_id *id) {
	printk("Probing device %s...\n", client->dev.of_node->name);
	return 0;
}

int sfp_remove(struct i2c_client *client) {

}

static const struct i2c_device_id sfp_id[] = {
	{ "vux_sfp", 0},
	{}
};

static struct i2c_driver sfp_driver = {
	.driver = {
		.name = "vux_sfp",
 	},
 	.probe = sfp_probe,
 	.remove = sfp_remove,
 	.id_table = sfp_id,
};

module_i2c_driver(sfp_driver);

MODULE_AUTHOR("VUX");
MODULE_DESCRIPTION("SFP DRIVER");
MODULE_LICENSE("GPL");
