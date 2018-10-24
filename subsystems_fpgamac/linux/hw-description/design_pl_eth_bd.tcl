
################################################################
# This is a generated script based on design: design_pl_eth
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_pl_eth_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z045ffg900-2

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name design_pl_eth

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: RESET_BLOCK
proc create_hier_cell_RESET_BLOCK { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_RESET_BLOCK() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 0 -to 0 dout
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir O -from 0 -to 0 -type rst interconnect_aresetn
  create_bd_pin -dir O -from 0 -to 0 -type rst interconnect_aresetn1
  create_bd_pin -dir I -type clk slowest_sync_clk
  create_bd_pin -dir I -type clk slowest_sync_clk1

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]
  set_property -dict [ list \
CONFIG.C_AUX_RST_WIDTH {1} \
CONFIG.C_EXT_RST_WIDTH {1} \
 ] $proc_sys_reset_0

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]
  set_property -dict [ list \
CONFIG.C_AUX_RST_WIDTH {1} \
CONFIG.C_EXT_RST_WIDTH {1} \
 ] $proc_sys_reset_1

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create port connections
  connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins interconnect_aresetn1] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
  connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins slowest_sync_clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net processing_system7_1_fclk_clk1 [get_bd_pins slowest_sync_clk1] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
  connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins interconnect_aresetn] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net processing_system7_FCLK_RESET0_N [get_bd_pins ext_reset_in] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins proc_sys_reset_1/ext_reset_in]
  connect_bd_net -net signal_detect_1 [get_bd_pins dout] [get_bd_pins xlconstant_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set mgt_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 mgt_clk ]
  set sfp [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sfp_rtl:1.0 sfp ]

  # Create ports
  set ref_clk [ create_bd_port -dir I -type clk ref_clk ]
  set_property -dict [ list \
CONFIG.CLK_DOMAIN {design_pl_eth_ref_clk} \
CONFIG.FREQ_HZ {100000000} \
CONFIG.PHASE {0.000} \
 ] $ref_clk

  # Create instance: RESET_BLOCK
  create_hier_cell_RESET_BLOCK [current_bd_instance .] RESET_BLOCK

  # Create instance: axi_dma, and set properties
  set axi_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma ]
  set_property -dict [ list \
CONFIG.c_include_mm2s_dre {1} \
CONFIG.c_include_s2mm_dre {1} \
CONFIG.c_sg_use_stsapp_length {1} \
 ] $axi_dma

  # Create instance: axi_ethernet, and set properties
  set axi_ethernet [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:7.0 axi_ethernet ]
  set_property -dict [ list \
CONFIG.PHYADDR {3} \
CONFIG.PHY_TYPE {1000BaseX} \
CONFIG.RXCSUM {Full} \
CONFIG.RXMEM {16k} \
CONFIG.TXCSUM {Full} \
CONFIG.TXMEM {16k} \
 ] $axi_ethernet

  # Create instance: axi_ic_GP, and set properties
  set axi_ic_GP [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_GP ]

  # Create instance: axi_ic_HP, and set properties
  set axi_ic_HP [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_HP ]
  set_property -dict [ list \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {3} \
CONFIG.S00_HAS_DATA_FIFO {2} \
CONFIG.S01_HAS_DATA_FIFO {2} \
CONFIG.S02_HAS_DATA_FIFO {2} \
CONFIG.STRATEGY {2} \
 ] $axi_ic_HP

  # Create instance: concat_intr, and set properties
  set concat_intr [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_intr ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {3} \
 ] $concat_intr

  # Create instance: processing_system7, and set properties
  set processing_system7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7 ]
  set_property -dict [ list \
CONFIG.PCW_EN_CLK1_PORT {1} \
CONFIG.PCW_EN_CLK2_PORT {1} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {125} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {75} \
CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_IMPORT_BOARD_PRESET {None} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
CONFIG.preset {ZC706} \
 ] $processing_system7

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dma_1_m_axi_mm2s [get_bd_intf_pins axi_dma/M_AXI_MM2S] [get_bd_intf_pins axi_ic_HP/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_1_m_axi_s2mm [get_bd_intf_pins axi_dma/M_AXI_S2MM] [get_bd_intf_pins axi_ic_HP/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma_1_m_axi_sg [get_bd_intf_pins axi_dma/M_AXI_SG] [get_bd_intf_pins axi_ic_HP/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_1_m_axis_cntrl [get_bd_intf_pins axi_dma/M_AXIS_CNTRL] [get_bd_intf_pins axi_ethernet/s_axis_txc]
  connect_bd_intf_net -intf_net axi_ethernet_1_axi_str_rxd [get_bd_intf_pins axi_dma/S_AXIS_S2MM] [get_bd_intf_pins axi_ethernet/m_axis_rxd]
  connect_bd_intf_net -intf_net axi_ethernet_1_axi_str_rxs [get_bd_intf_pins axi_dma/S_AXIS_STS] [get_bd_intf_pins axi_ethernet/m_axis_rxs]
  connect_bd_intf_net -intf_net axi_ethernet_1_sfp [get_bd_intf_ports sfp] [get_bd_intf_pins axi_ethernet/sfp]
  connect_bd_intf_net -intf_net axi_interconnect_1_m00_axi [get_bd_intf_pins axi_dma/S_AXI_LITE] [get_bd_intf_pins axi_ic_GP/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_2_M00_AXI [get_bd_intf_pins axi_ic_HP/M00_AXI] [get_bd_intf_pins processing_system7/S_AXI_HP0]
  connect_bd_intf_net -intf_net axi_str_txd_1 [get_bd_intf_pins axi_dma/M_AXIS_MM2S] [get_bd_intf_pins axi_ethernet/s_axis_txd]
  connect_bd_intf_net -intf_net mgt_clk_1 [get_bd_intf_ports mgt_clk] [get_bd_intf_pins axi_ethernet/mgt_clk]
  connect_bd_intf_net -intf_net processing_system7_1_ddr [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7/DDR]
  connect_bd_intf_net -intf_net processing_system7_1_fixed_io [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_1_m_axi_gp0 [get_bd_intf_pins axi_ic_GP/S00_AXI] [get_bd_intf_pins processing_system7/M_AXI_GP0]
  connect_bd_intf_net -intf_net s_axi_1 [get_bd_intf_pins axi_ethernet/s_axi] [get_bd_intf_pins axi_ic_GP/M01_AXI]

  # Create port connections
  connect_bd_net -net axi_dma_1_mm2s_introut [get_bd_pins axi_dma/mm2s_introut] [get_bd_pins concat_intr/In1]
  connect_bd_net -net axi_dma_1_s2mm_introut [get_bd_pins axi_dma/s2mm_introut] [get_bd_pins concat_intr/In0]
  connect_bd_net -net axi_dma_mm2s_cntrl_reset_out_n [get_bd_pins axi_dma/mm2s_cntrl_reset_out_n] [get_bd_pins axi_ethernet/axi_txc_arstn]
  connect_bd_net -net axi_dma_mm2s_prmry_reset_out_n [get_bd_pins axi_dma/mm2s_prmry_reset_out_n] [get_bd_pins axi_ethernet/axi_txd_arstn]
  connect_bd_net -net axi_dma_s2mm_prmry_reset_out_n [get_bd_pins axi_dma/s2mm_prmry_reset_out_n] [get_bd_pins axi_ethernet/axi_rxd_arstn]
  connect_bd_net -net axi_dma_s2mm_sts_reset_out_n [get_bd_pins axi_dma/s2mm_sts_reset_out_n] [get_bd_pins axi_ethernet/axi_rxs_arstn]
  connect_bd_net -net axi_ethernet_1_interrupt [get_bd_pins axi_ethernet/interrupt] [get_bd_pins concat_intr/In2]
  connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins RESET_BLOCK/interconnect_aresetn1] [get_bd_pins axi_dma/axi_resetn] [get_bd_pins axi_ethernet/s_axi_lite_resetn] [get_bd_pins axi_ic_GP/ARESETN] [get_bd_pins axi_ic_GP/M00_ARESETN] [get_bd_pins axi_ic_GP/M01_ARESETN] [get_bd_pins axi_ic_GP/S00_ARESETN]
  connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins RESET_BLOCK/slowest_sync_clk] [get_bd_pins axi_dma/m_axi_mm2s_aclk] [get_bd_pins axi_dma/m_axi_s2mm_aclk] [get_bd_pins axi_dma/m_axi_sg_aclk] [get_bd_pins axi_ethernet/axis_clk] [get_bd_pins axi_ic_HP/ACLK] [get_bd_pins axi_ic_HP/M00_ACLK] [get_bd_pins axi_ic_HP/S00_ACLK] [get_bd_pins axi_ic_HP/S01_ACLK] [get_bd_pins axi_ic_HP/S02_ACLK] [get_bd_pins processing_system7/FCLK_CLK0] [get_bd_pins processing_system7/S_AXI_HP0_ACLK]
  connect_bd_net -net processing_system7_1_fclk_clk1 [get_bd_pins RESET_BLOCK/slowest_sync_clk1] [get_bd_pins axi_dma/s_axi_lite_aclk] [get_bd_pins axi_ethernet/s_axi_lite_clk] [get_bd_pins axi_ic_GP/ACLK] [get_bd_pins axi_ic_GP/M00_ACLK] [get_bd_pins axi_ic_GP/M01_ACLK] [get_bd_pins axi_ic_GP/S00_ACLK] [get_bd_pins processing_system7/FCLK_CLK1] [get_bd_pins processing_system7/M_AXI_GP0_ACLK]
  connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_pins RESET_BLOCK/interconnect_aresetn] [get_bd_pins axi_ic_HP/ARESETN] [get_bd_pins axi_ic_HP/M00_ARESETN] [get_bd_pins axi_ic_HP/S00_ARESETN] [get_bd_pins axi_ic_HP/S01_ARESETN] [get_bd_pins axi_ic_HP/S02_ARESETN]
  connect_bd_net -net processing_system7_FCLK_RESET0_N [get_bd_pins RESET_BLOCK/ext_reset_in] [get_bd_pins processing_system7/FCLK_RESET0_N]
  connect_bd_net -net ref_clk_1 [get_bd_ports ref_clk] [get_bd_pins axi_ethernet/ref_clk]
  connect_bd_net -net signal_detect_1 [get_bd_pins RESET_BLOCK/dout] [get_bd_pins axi_ethernet/signal_detect]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins concat_intr/dout] [get_bd_pins processing_system7/IRQ_F2P]

  # Create address segments
  create_bd_addr_seg -range 0x40000000 -offset 0x0 [get_bd_addr_spaces axi_dma/Data_SG] [get_bd_addr_segs processing_system7/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_1_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x0 [get_bd_addr_spaces axi_dma/Data_MM2S] [get_bd_addr_segs processing_system7/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_1_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x0 [get_bd_addr_spaces axi_dma/Data_S2MM] [get_bd_addr_segs processing_system7/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_1_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x10000 -offset 0x40400000 [get_bd_addr_spaces processing_system7/Data] [get_bd_addr_segs axi_dma/S_AXI_LITE/Reg] SEG4
  create_bd_addr_seg -range 0x40000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7/Data] [get_bd_addr_segs axi_ethernet/s_axi/Reg0] SEG_axi_ethernet_1_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   Display-PortTypeClock: "true",
   Display-PortTypeInterrupt: "true",
   Display-PortTypeOthers: "true",
   Display-PortTypeReset: "true",
   comment_0: "PL ETHERNET DESIGN",
   commentid: "comment_0|",
   fillcolor_comment_0: "",
   font_comment_0: "43",
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port DDR -pg 1 -y 570 -defaultsOSRD
preplace port ref_clk -pg 1 -y 310 -defaultsOSRD
preplace port sfp -pg 1 -y 350 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 590 -defaultsOSRD
preplace port mgt_clk -pg 1 -y 130 -defaultsOSRD
preplace inst axi_dma -pg 1 -lvl 4 -y 150 -defaultsOSRD
preplace inst axi_ic_HP -pg 1 -lvl 5 -y 170 -defaultsOSRD
preplace inst concat_intr -pg 1 -lvl 5 -y 430 -defaultsOSRD
preplace inst processing_system7 -pg 1 -lvl 6 -y 670 -defaultsOSRD
preplace inst RESET_BLOCK -pg 1 -lvl 1 -y 440 -defaultsOSRD
preplace inst axi_ic_GP -pg 1 -lvl 2 -y 660 -defaultsOSRD
preplace inst axi_ethernet -pg 1 -lvl 3 -y 190 -defaultsOSRD
preplace netloc processing_system7_1_ddr 1 6 1 NJ
preplace netloc axi_dma_1_m_axi_mm2s 1 4 1 N
preplace netloc axi_dma_mm2s_prmry_reset_out_n 1 2 3 840 420 NJ 410 1550
preplace netloc axi_dma_mm2s_cntrl_reset_out_n 1 2 3 810 450 NJ 450 1580
preplace netloc axi_dma_1_m_axi_s2mm 1 4 1 N
preplace netloc processing_system7_FCLK_RESET0_N 1 0 7 20 520 NJ 520 NJ 520 NJ 520 NJ 520 NJ 510 2450
preplace netloc processing_system7_1_fclk_clk0 1 0 7 40 510 NJ 490 780 400 1210 440 1620 360 1980 520 2430
preplace netloc axi_ethernet_1_interrupt 1 3 2 1140 490 NJ
preplace netloc s_axi_1 1 2 1 750
preplace netloc ref_clk_1 1 0 3 NJ 310 NJ 310 NJ
preplace netloc processing_system7_1_fclk_clk1 1 0 7 30 530 420 510 770 390 1180 610 NJ 610 1950 820 2430
preplace netloc axi_ethernet_1_axi_str_rxd 1 3 1 1210
preplace netloc axi_dma_1_m_axi_sg 1 4 1 N
preplace netloc axi_ethernet_1_sfp 1 3 4 NJ 350 NJ 350 NJ 350 NJ
preplace netloc xlconcat_1_dout 1 5 1 1960
preplace netloc signal_detect_1 1 1 2 NJ 420 760
preplace netloc axi_dma_1_s2mm_introut 1 4 1 1630
preplace netloc axi_ethernet_1_axi_str_rxs 1 3 1 1180
preplace netloc processing_system7_1_fixed_io 1 6 1 NJ
preplace netloc processing_system7_1_fclk_reset0_n 1 1 4 NJ 450 NJ 480 NJ 480 1640
preplace netloc axi_dma_s2mm_prmry_reset_out_n 1 2 3 820 460 NJ 460 1570
preplace netloc processing_system7_1_m_axi_gp0 1 1 6 430 500 NJ 500 NJ 500 NJ 500 NJ 500 2440
preplace netloc mgt_clk_1 1 0 3 NJ 130 NJ 130 NJ
preplace netloc axi_dma_1_m_axis_cntrl 1 2 3 800 430 NJ 420 1590
preplace netloc axi_str_txd_1 1 2 3 790 440 NJ 430 1600
preplace netloc axi_interconnect_1_m00_axi 1 2 2 NJ 650 1160
preplace netloc proc_sys_reset_1_interconnect_aresetn 1 1 3 400 460 730 410 NJ
preplace netloc axi_interconnect_2_M00_AXI 1 5 1 1990
preplace netloc axi_dma_s2mm_sts_reset_out_n 1 2 3 830 470 NJ 470 1560
preplace netloc axi_dma_1_mm2s_introut 1 4 1 1610
preplace cgraphic comment_0 place abs 1134 -85 textcolor 6 linecolor 3 linewidth 2
levelinfo -pg 1 0 220 580 990 1380 1800 2210 2470 -top 0 -bot 830
",
   linecolor_comment_0: "",
   textcolor_comment_0: "#008000",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


