
################################################################
# This is a generated script based on design: design_ps_emio
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
# source design_ps_emio_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z045ffg900-2

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name design_ps_emio

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


# Hierarchical cell: drive_constants
proc create_hier_cell_drive_constants { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_drive_constants() - Empty argument(s)!"
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
  create_bd_pin -dir O -from 0 -to 0 dout1
  create_bd_pin -dir O -from 0 -to 0 dout2
  create_bd_pin -dir O -from 15 -to 0 dout3
  create_bd_pin -dir O -from 0 -to 0 dout4
  create_bd_pin -dir O -from 4 -to 0 dout5

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
CONFIG.CONST_WIDTH {5} \
 ] $xlconstant_1

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
CONFIG.CONST_WIDTH {1} \
 ] $xlconstant_2

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {100001} \
CONFIG.CONST_WIDTH {16} \
 ] $xlconstant_3

  # Create instance: xlconstant_5, and set properties
  set xlconstant_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_5 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {1} \
CONFIG.CONST_WIDTH {1} \
 ] $xlconstant_5

  # Create instance: xlconstant_6, and set properties
  set xlconstant_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_6 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
 ] $xlconstant_6

  # Create instance: xlconstant_7, and set properties
  set xlconstant_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_7 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {1} \
 ] $xlconstant_7

  # Create port connections
  connect_bd_net -net xlconstant_1_const [get_bd_pins dout5] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_2_const [get_bd_pins dout1] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins dout3] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlconstant_5_dout [get_bd_pins dout] [get_bd_pins xlconstant_5/dout]
  connect_bd_net -net xlconstant_6_dout [get_bd_pins dout2] [get_bd_pins xlconstant_6/dout]
  connect_bd_net -net xlconstant_7_dout [get_bd_pins dout4] [get_bd_pins xlconstant_7/dout]

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
  set gtrefclk_in [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gtrefclk_in ]
  set sfp [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sfp_rtl:1.0 sfp ]

  # Create ports
  set FCLK_CLK0 [ create_bd_port -dir O -type clk FCLK_CLK0 ]
  set FCLK_RESET0_N [ create_bd_port -dir O -type rst FCLK_RESET0_N ]
  set independent_clock_bufg [ create_bd_port -dir I -type clk independent_clock_bufg ]
  set_property -dict [ list \
CONFIG.CLK_DOMAIN {design_ps_emio_independent_clock_bufg} \
CONFIG.FREQ_HZ {100000000} \
CONFIG.PHASE {0.000} \
 ] $independent_clock_bufg
  set status_vector [ create_bd_port -dir O -from 15 -to 0 status_vector ]
  set userclk2_out [ create_bd_port -dir O -type clk userclk2_out ]

  # Create instance: drive_constants
  create_hier_cell_drive_constants [current_bd_instance .] drive_constants

  # Create instance: gig_ethernet_pcs_pma_1, and set properties
  set gig_ethernet_pcs_pma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:gig_ethernet_pcs_pma:15.1 gig_ethernet_pcs_pma_1 ]
  set_property -dict [ list \
CONFIG.C_PHYADDR {6} \
CONFIG.EMAC_IF_TEMAC {GEM} \
CONFIG.SupportLevel {Include_Shared_Logic_in_Core} \
 ] $gig_ethernet_pcs_pma_1

  # Create instance: processing_system7_1, and set properties
  set processing_system7_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_1 ]
  set_property -dict [ list \
CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} \
CONFIG.PCW_GPIO_EMIO_GPIO_IO {1} \
CONFIG.PCW_USE_M_AXI_GP0 {0} \
CONFIG.preset {ZC706} \
 ] $processing_system7_1

  # Create interface connections
  connect_bd_intf_net -intf_net gig_ethernet_pcs_pma_1_sfp [get_bd_intf_ports sfp] [get_bd_intf_pins gig_ethernet_pcs_pma_1/sfp]
  connect_bd_intf_net -intf_net gtrefclk_in_1 [get_bd_intf_ports gtrefclk_in] [get_bd_intf_pins gig_ethernet_pcs_pma_1/gtrefclk_in]
  connect_bd_intf_net -intf_net processing_system7_1_ddr [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_1/DDR]
  connect_bd_intf_net -intf_net processing_system7_1_fixed_io [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_1/FIXED_IO]

  # Create port connections
  connect_bd_net -net gig_ethernet_pcs_pma_1_gmii_rx_dv [get_bd_pins gig_ethernet_pcs_pma_1/gmii_rx_dv] [get_bd_pins processing_system7_1/ENET1_GMII_RX_DV]
  connect_bd_net -net gig_ethernet_pcs_pma_1_gmii_rx_er [get_bd_pins gig_ethernet_pcs_pma_1/gmii_rx_er] [get_bd_pins processing_system7_1/ENET1_GMII_RX_ER]
  connect_bd_net -net gig_ethernet_pcs_pma_1_gmii_rxd [get_bd_pins gig_ethernet_pcs_pma_1/gmii_rxd] [get_bd_pins processing_system7_1/ENET1_GMII_RXD]
  connect_bd_net -net gig_ethernet_pcs_pma_1_mdio_o [get_bd_pins gig_ethernet_pcs_pma_1/mdio_o] [get_bd_pins processing_system7_1/ENET1_MDIO_I]
  connect_bd_net -net gig_ethernet_pcs_pma_1_status_vector [get_bd_ports status_vector] [get_bd_pins gig_ethernet_pcs_pma_1/status_vector]
  connect_bd_net -net gig_ethernet_pcs_pma_1_userclk2_out [get_bd_ports userclk2_out] [get_bd_pins gig_ethernet_pcs_pma_1/userclk2_out] [get_bd_pins processing_system7_1/ENET1_GMII_RX_CLK] [get_bd_pins processing_system7_1/ENET1_GMII_TX_CLK]
  connect_bd_net -net independent_clock_bufg_1 [get_bd_ports independent_clock_bufg] [get_bd_pins gig_ethernet_pcs_pma_1/independent_clock_bufg]
  connect_bd_net -net processing_system7_1_GPIO_O [get_bd_pins gig_ethernet_pcs_pma_1/reset] [get_bd_pins processing_system7_1/GPIO_O]
  connect_bd_net -net processing_system7_1_enet1_gmii_tx_en [get_bd_pins gig_ethernet_pcs_pma_1/gmii_tx_en] [get_bd_pins processing_system7_1/ENET1_GMII_TX_EN]
  connect_bd_net -net processing_system7_1_enet1_gmii_tx_er [get_bd_pins gig_ethernet_pcs_pma_1/gmii_tx_er] [get_bd_pins processing_system7_1/ENET1_GMII_TX_ER]
  connect_bd_net -net processing_system7_1_enet1_gmii_txd [get_bd_pins gig_ethernet_pcs_pma_1/gmii_txd] [get_bd_pins processing_system7_1/ENET1_GMII_TXD]
  connect_bd_net -net processing_system7_1_enet1_mdio_mdc [get_bd_pins gig_ethernet_pcs_pma_1/mdc] [get_bd_pins processing_system7_1/ENET1_MDIO_MDC]
  connect_bd_net -net processing_system7_1_enet1_mdio_o [get_bd_pins gig_ethernet_pcs_pma_1/mdio_i] [get_bd_pins processing_system7_1/ENET1_MDIO_O]
  connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_ports FCLK_CLK0] [get_bd_pins processing_system7_1/FCLK_CLK0]
  connect_bd_net -net processing_system7_1_fclk_reset0_n [get_bd_ports FCLK_RESET0_N] [get_bd_pins processing_system7_1/FCLK_RESET0_N]
  connect_bd_net -net xlconstant_1_const [get_bd_pins drive_constants/dout5] [get_bd_pins gig_ethernet_pcs_pma_1/configuration_vector]
  connect_bd_net -net xlconstant_2_const [get_bd_pins drive_constants/dout1] [get_bd_pins gig_ethernet_pcs_pma_1/an_adv_config_val] [get_bd_pins gig_ethernet_pcs_pma_1/an_restart_config] [get_bd_pins gig_ethernet_pcs_pma_1/configuration_valid]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins drive_constants/dout3] [get_bd_pins gig_ethernet_pcs_pma_1/an_adv_config_vector]
  connect_bd_net -net xlconstant_5_dout [get_bd_pins drive_constants/dout] [get_bd_pins gig_ethernet_pcs_pma_1/signal_detect]
  connect_bd_net -net xlconstant_6_dout [get_bd_pins drive_constants/dout2] [get_bd_pins processing_system7_1/ENET1_GMII_COL]
  connect_bd_net -net xlconstant_7_dout [get_bd_pins drive_constants/dout4] [get_bd_pins processing_system7_1/ENET1_GMII_CRS]

  # Create address segments

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   comment_0: "ZC706 PS EMIO ETHERNET DESIGN",
   comment_1: "GIG ETHERNET
    PCS PMA",
   commentid: "comment_0|comment_1|",
   fillcolor_comment_1: "",
   font_comment_0: "45",
   font_comment_1: "54",
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port DDR -pg 1 -y 880 -defaultsOSRD
preplace port FCLK_RESET0_N -pg 1 -y 1020 -defaultsOSRD
preplace port independent_clock_bufg -pg 1 -y 290 -defaultsOSRD
preplace port userclk2_out -pg 1 -y 170 -defaultsOSRD
preplace port sfp -pg 1 -y 110 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 900 -defaultsOSRD
preplace port FCLK_CLK0 -pg 1 -y 1000 -defaultsOSRD
preplace port gtrefclk_in -pg 1 -y 270 -defaultsOSRD
preplace portBus status_vector -pg 1 -y 330 -defaultsOSRD
preplace inst processing_system7_1 -pg 1 -lvl 1 -y 780 -defaultsOSRD
preplace inst drive_constants -pg 1 -lvl 1 -y 390 -defaultsOSRD
preplace inst gig_ethernet_pcs_pma_1 -pg 1 -lvl 2 -y 240 -defaultsOSRD -resize 556 450
preplace netloc processing_system7_1_ddr 1 1 2 NJ 880 NJ
preplace netloc xlconstant_5_dout 1 1 1 750
preplace netloc processing_system7_1_fclk_clk0 1 1 2 NJ 1000 NJ
preplace netloc xlconstant_1_const 1 1 1 740
preplace netloc processing_system7_1_enet1_gmii_tx_er 1 1 1 730
preplace netloc independent_clock_bufg_1 1 0 2 NJ 280 NJ
preplace netloc gig_ethernet_pcs_pma_1_status_vector 1 2 1 NJ
preplace netloc gig_ethernet_pcs_pma_1_gmii_rx_er 1 1 1 720
preplace netloc gig_ethernet_pcs_pma_1_gmii_rx_dv 1 1 1 690
preplace netloc gig_ethernet_pcs_pma_1_sfp 1 2 1 NJ
preplace netloc gig_ethernet_pcs_pma_1_mdio_o 1 1 1 790
preplace netloc xlconstant_7_dout 1 1 1 670
preplace netloc processing_system7_1_fixed_io 1 1 2 NJ 900 NJ
preplace netloc processing_system7_1_fclk_reset0_n 1 1 2 NJ 1020 NJ
preplace netloc processing_system7_1_GPIO_O 1 1 1 820
preplace netloc xlconstant_2_const 1 1 1 820
preplace netloc processing_system7_1_enet1_gmii_txd 1 1 1 780
preplace netloc gtrefclk_in_1 1 0 2 NJ 270 NJ
preplace netloc xlconstant_6_dout 1 1 1 680
preplace netloc processing_system7_1_enet1_mdio_o 1 1 1 760
preplace netloc gig_ethernet_pcs_pma_1_userclk2_out 1 1 2 810 490 1420
preplace netloc processing_system7_1_enet1_gmii_tx_en 1 1 1 700
preplace netloc gig_ethernet_pcs_pma_1_gmii_rxd 1 1 1 800
preplace netloc xlconstant_3_dout 1 1 1 770
preplace netloc processing_system7_1_enet1_mdio_mdc 1 1 1 710
preplace cgraphic comment_1 place abs 891 164 textcolor 4 linecolor 3 linewidth 2
preplace cgraphic comment_0 place abs 584 -56 textcolor 6 linecolor 3 linewidth 0
levelinfo -pg 1 190 440 1120 1450 -top 0 -bot 1070
",
   linecolor_comment_1: "",
   linktoobj_comment_1: "/gig_ethernet_pcs_pma_1",
   linktotype_comment_1: "bd_cell",
   textcolor_comment_0: "#008000",
   textcolor_comment_1: "",
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


