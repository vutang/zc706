

typedef struct vux_sfp_dev {
	int id;
	void *priv_data;
	struct list_head list;
} vux_sfp_dev_t;

vux_sfp_dev_t* sfp_dev_register(struct i2c_client* client, int dev_id);
