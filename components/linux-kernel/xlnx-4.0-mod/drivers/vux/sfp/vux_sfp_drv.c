/*
* @Author: vutang
* @Date:   2018-10-15 17:50:54
* @Last Modified by:   vutang
* @Last Modified time: 2018-10-16 10:35:50
*/

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/device.h>
/*For kmalloc/kfree*/
#include <linux/slab.h>

#include <linux/io.h>

/*For i2c_client*/
#include <linux/i2c.h>

#include "vux_sfp.h"

struct sfp_drvdata {
	struct i2c_client *client;	
};

static int sfp_probe(struct i2c_client *client,
			 const struct i2c_device_id *id) {
	dev_info(&client->dev, "Probing i2c device 0x%x...\n", client->addr);
	
	struct sfp_drvdata *p_sfp_drvdata = (struct sfp_drvdata *) NULL;
	/*Got device from i2c_client*/
	struct device *dev = &client->dev;

	vux_sfp_dev_t *p_vux_sfp_dev;

	int ret;
	u8 vendor_part_number[21];

	/*Allocate driver data*/
	p_sfp_drvdata = (struct sfp_drvdata *) kmalloc(sizeof(struct sfp_drvdata), GFP_KERNEL);
	if (!p_sfp_drvdata) {
		dev_err(&client->dev, "Could not allocate driver data");
		goto err_alloc_sfp_drvdata;
	}

	/*Set driver data*/
	dev_set_drvdata(dev, p_sfp_drvdata);

	p_vux_sfp_dev = (vux_sfp_dev_t *) kmalloc(sizeof(vux_sfp_dev_t), GFP_KERNEL);
	if (!p_vux_sfp_dev) {
		dev_err(*client->dev, "Allocate vux_dev fail");
		goto err_alloc_vux_dev;
	}

	/*Got id device from i2c_device_id table*/
	p_vux_sfp_dev->id = id->driver_data;

	return 0;

err_alloc_vux_dev:
	kfree(p_sfp_drvdata);
err_alloc_sfp_drvdata:
	return -1;
}

int sfp_remove(struct i2c_client *client) {
	/*dev_get_drvdata & dev_set_drvdata are function defined in linux/device.h*/
	struct sfp_drvdata *p = dev_get_drvdata(&client->dev);
	kfree(p);
}

/*Define in mod_devicetable.h, include: name & driver_data*/
static const struct i2c_device_id sfp_id[] = {
	{ "vux_sfp_0", 0},
	{ "vux_sfp_1", 1},
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
