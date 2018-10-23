#include "xparameters.h"
#include "xil_printf.h"
#include "xiicps.h"
#include "sleep.h"
#include "xscugic.h"

/*NOTE : The I2C slave address for the SFP/SFP+ module depends on the PHY
 *on the module connected to the SFP/SFP+ connector.
 *Please refer to the datasheet for the module you are using.
 *For more info : Refer AR http://www.xilinx.com/support/answers/63038.html
 */
#define IIC_SLAVE_ADDR		0x56
#define IIC_MUX_ADDRESS		0x74
#define IIC_CHANNEL_ADDRESS	0x01

#define XIIC	XIicPs
#define INTC	XScuGic
/**************************** Type Definitions *******************************/
typedef struct {
	XIIC I2cInstance;
	INTC IntcInstance;
	volatile u8 TransmitComplete;   /* Flag to check completion of Transmission */
	volatile u8 ReceiveComplete;    /* Flag to check completion of Reception */
	volatile u32 TotalErrorCount;
} XIIC_LIB;
/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/
int I2cWriteData(XIIC_LIB *I2cLibPtr, u8 *WrBuffer, u16 ByteCount, u16 SlaveAddr);
int I2cReadData(XIIC_LIB *I2cLibPtr, u8 *RdBuffer, u16 ByteCount, u16 SlaveAddr);
int I2cPhyWrite(XIIC_LIB *I2cLibPtr, u8 PhyAddr, u8 Reg, u16 Data, u16 SlaveAddr);
int I2cPhyRead(XIIC_LIB *I2cLibPtr, u8 PhyAddr, u8 Reg, u16 *Data, u16 SlaveAddr);
int I2cSetupHardware(XIIC_LIB *I2cLibPtr);
/************************** Function Definitions *****************************/

/*****************************************************************************/
/**
 * This function initializes ZC706 MUX.
 *
 * @param	I2cLibPtr contains a pointer to the instance of the IIC library
 *
 * @return	XST_SUCCESS if successful else XST_FAILURE.
 *
 ******************************************************************************/
int ZC706MuxInit(XIIC_LIB *I2cLibInstancePtr)
{
	u8 WrBuffer;
	int Status;
	WrBuffer = IIC_CHANNEL_ADDRESS;

	Status = I2cWriteData(I2cLibInstancePtr, &WrBuffer, 1, IIC_MUX_ADDRESS);
	if (Status != XST_SUCCESS) {
		xil_printf("SFP_PHY: Writing failed\n\r");
		return XST_FAILURE;
 	}
	return XST_SUCCESS;
}

/*****************************************************************************/
/**
 * This function program SFP PHY.
 *
 * @return	XST_SUCCESS if successful else XST_FAILURE.
 *
 ******************************************************************************/
int ProgramSfpPhy(void)
{
	XIIC_LIB I2cLibInstance;
	int Status;
	u8 WrBuffer[2];
	u16 phy_read_val;

	//xil_printf("ProgramSfpPhy start\n\r");
	Status = I2cSetupHardware(&I2cLibInstance);
	if (Status != XST_SUCCESS) {
		xil_printf("Fail!!!\n\r");
		xil_printf("SFP_PHY: Configuring HW failed\n\r");
		return XST_FAILURE;
	}

	//xil_printf("ProgramSfpPhy mux init\n\r");
	Status = ZC706MuxInit(&I2cLibInstance);
	if (Status != XST_SUCCESS) {
		xil_printf("SFP_PHY: Mux Init failed\n\r");
		return XST_FAILURE;
	}
	//xil_printf("ProgramSfpPhy write data\n\r");
	WrBuffer[0] = 0;
	Status = I2cWriteData(&I2cLibInstance, WrBuffer, 1, IIC_SLAVE_ADDR);
	if (Status != XST_SUCCESS) {
		xil_printf("SFP_PHY: Writing failed\n\r");
		return XST_FAILURE;
	}

	//xil_printf("ProgramSfpPhy en sgmii\n\r");
	/* Enabling SGMII */
	I2cPhyWrite(&I2cLibInstance, IIC_SLAVE_ADDR, 0x1B, 0x9084, IIC_SLAVE_ADDR);

	//xil_printf("ProgramSfpPhy sw reset\n\r");
	/* Apply Soft Reset */
	I2cPhyWrite(&I2cLibInstance, IIC_SLAVE_ADDR, 0x00, 0x9140, IIC_SLAVE_ADDR);

	//xil_printf("ProgramSfpPhy full\n\r");
	/* Enable 1000BaseT Full Duplex capabilities */
	I2cPhyWrite(&I2cLibInstance, IIC_SLAVE_ADDR, 0x09, 0x0E00, IIC_SLAVE_ADDR);

	//xil_printf("ProgramSfpPhy sw reset2\n\r");
	/* Apply Soft Reset */
	I2cPhyWrite(&I2cLibInstance, IIC_SLAVE_ADDR, 0x00, 0x9140, IIC_SLAVE_ADDR);

	//xil_printf("ProgramSfpPhy adv 10/100\n\r");
	/* Advertise 10/100 Capabilities else change the capabilities */
	I2cPhyWrite(&I2cLibInstance, IIC_SLAVE_ADDR, 0x04, 0x0141, IIC_SLAVE_ADDR);

	//xil_printf("ProgramSfpPhy sw reset3\n\r");
	/* Apply Soft Reset */
	I2cPhyWrite(&I2cLibInstance, IIC_SLAVE_ADDR, 0x00, 0x9140, IIC_SLAVE_ADDR);

	//xil_printf("ProgramSfpPhy sw reset4\n\r");
	/* Apply Soft Reset */
	I2cPhyWrite(&I2cLibInstance, IIC_SLAVE_ADDR, 0x00, 0x9140, IIC_SLAVE_ADDR);
	//xil_printf("ProgramSfpPhy 0x10\n\r");
	I2cPhyWrite(&I2cLibInstance, IIC_SLAVE_ADDR, 0x10, 0xF079, IIC_SLAVE_ADDR);
	//xil_printf("ProgramSfpPhy sw reset5\n\r");
	/* Apply Soft Reset */
	I2cPhyWrite(&I2cLibInstance, IIC_SLAVE_ADDR, 0x00, 0x9140, IIC_SLAVE_ADDR);

	//xil_printf("ProgramSfpPhy 0x16\n\r");
	I2cPhyWrite(&I2cLibInstance, IIC_SLAVE_ADDR, 0x16, 0x0001, IIC_SLAVE_ADDR);
	//xil_printf("ProgramSfpPhy sw reset6\n\r");
	I2cPhyWrite(&I2cLibInstance, IIC_SLAVE_ADDR, 0x00, 0x9140, IIC_SLAVE_ADDR);
	//xil_printf("ProgramSfpPhy sw reset7\n\r");
	I2cPhyWrite(&I2cLibInstance, IIC_SLAVE_ADDR, 0x00, 0x9340, IIC_SLAVE_ADDR);
	usleep(1);

	//xil_printf("ProgramSfpPhy 0x16 0\n\r");
	I2cPhyWrite(&I2cLibInstance, IIC_SLAVE_ADDR, 0x16, 0x0, IIC_SLAVE_ADDR);
	phy_read_val = 0x0;

	I2cPhyWrite(&I2cLibInstance, IIC_SLAVE_ADDR, 0x16, 0x0, IIC_SLAVE_ADDR);
	I2cPhyRead(&I2cLibInstance, IIC_SLAVE_ADDR, 0x11, &phy_read_val, IIC_SLAVE_ADDR);
	I2cPhyWrite(&I2cLibInstance, IIC_SLAVE_ADDR, 0x16, 0x0001, IIC_SLAVE_ADDR);

	//xil_printf("ProgramSfpPhy speed\n\r");
	/* configure speed */
	I2cPhyWrite(&I2cLibInstance, IIC_SLAVE_ADDR, 0x14, 0x0c61, IIC_SLAVE_ADDR);
	I2cPhyWrite(&I2cLibInstance, IIC_SLAVE_ADDR, 0x00, 0x9340, IIC_SLAVE_ADDR);
	I2cPhyWrite(&I2cLibInstance, IIC_SLAVE_ADDR, 0x16, 0x0, IIC_SLAVE_ADDR);

	//xil_printf("ProgramSfpPhy done\n\r");
	return XST_SUCCESS;
}