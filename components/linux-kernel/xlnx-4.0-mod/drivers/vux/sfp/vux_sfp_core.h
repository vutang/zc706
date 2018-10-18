#include <linux/notifier.h>

typedef struct sfp_drvdata {
	struct i2c_client *client;	
	int id;
} sfp_drvdata_t;

void sfp_register_notify(struct notifier_block *nb);
void sfp_add_device(sfp_drvdata_t *sfp_drvdata);