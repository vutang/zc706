/*
* @Author: vutang
* @Date:   2018-10-15 17:50:54
* @Last Modified by:   vutang
* @Last Modified time: 2018-10-19 11:54:20
*/

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/device.h>
/*For kmalloc/kfree*/
#include <linux/slab.h>

#include <linux/io.h>
/*For i2c_client*/
#include <linux/i2c.h>

#include "vux_sfp_core.h"
#include "vux_sfp.h"

static int sfp_probe(struct i2c_client *client, const struct i2c_device_id *id) {
	int ret;
	sfp_drvdata_t *p_sfp_drvdata = (sfp_drvdata_t *) NULL;

	dev_info(&client->dev, "Probing i2c device 0x%x...\n", client->addr);

	/*Allocate driver data*/
	p_sfp_drvdata = (sfp_drvdata_t *) kmalloc(sizeof(struct sfp_drvdata), GFP_KERNEL);
	if (!p_sfp_drvdata) {
		dev_err(&client->dev, "Could not allocate driver data");
		goto err_alloc_sfp_drvdata;
	}

	p_sfp_drvdata->client = client;
	p_sfp_drvdata->id = id->driver_data;
	
	/*Add device to system, a character device file will be created*/
	sfp_add_device(p_sfp_drvdata);
	return 0;
err_alloc_sfp_drvdata:
	return -1;
}

int sfp_remove(struct i2c_client *client) {
	struct sfp_drvdata *p = dev_get_drvdata(&client->dev);
	kfree(p);
	return 0;
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
