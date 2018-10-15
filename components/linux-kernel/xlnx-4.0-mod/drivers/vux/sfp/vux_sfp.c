/*
* @Author: vutang
* @Date:   2018-10-15 17:50:54
* @Last Modified by:   vutang
* @Last Modified time: 2018-10-15 19:50:12
*/

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/device.h>
/*For kmallo/kfree*/
#include <linux/slab.h>

#include <linux/io.h>

/*For i2c_client*/
#include <linux/i2c.h>

struct sfp_drvdata {
	struct i2c_client *client;	
};

static int sfp_probe(struct i2c_client *client,
			 const struct i2c_device_id *id) {
	dev_info(&client->dev, "Probing device %s...\n", client->dev.of_node->name);
	
	struct sfp_drvdata *p_sfp_drvdata = (struct sfp_drvdata *) NULL;
	/*Got device from i2c_client*/
	struct device *dev = &client->dev;

	int ret;
	u8 vendor_part_number[21];

	/*Allocate driver data*/
	p_sfp_drvdata = (struct sfp_drvdata *) kmalloc(sizeof(struct sfp_drvdata), GFP_KERNEL);
	if (!p_sfp_drvdata) {
		dev_err(&client->dev, "Could not allocate driver data");
	}


	ret = i2c_smbus_read_byte_data(client, 0x00);
	printk("Ret: 0x%x\n", ret);
	// ret = i2c_smbus_read_block_data(client, 40, &vendor_part_number[0]);
	// vendor_part_number[20] = '\0';
	// printk("vendor_part_number: %s\n", vendor_part_number);


	/*Set driver data*/
	dev_set_drvdata(dev, p_sfp_drvdata);
	return 0;
}

int sfp_remove(struct i2c_client *client) {
	/*dev_get_drvdata & dev_set_drvdata are function defined in linux/device.h*/
	struct sfp_drvdata *p = dev_get_drvdata(&client->dev);
	kfree(p);
}

static const struct i2c_device_id sfp_id[] = {
	{ "vux_sfp", 0},
	{}
};

static struct i2c_driver sfp_driver = {
	.driver = {
		.name = "sfp",
 	},
 	.probe = sfp_probe,
 	.remove = sfp_remove,
 	.id_table = sfp_id,
};

module_i2c_driver(sfp_driver);

MODULE_AUTHOR("VUX");
MODULE_DESCRIPTION("SFP DRIVER");
MODULE_LICENSE("GPL");
