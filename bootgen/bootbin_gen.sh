# #!/bin/sh
home_dir="$PROOT"
echo "Home Directory is $home_dir"

# echo the_ROM_image: > output-golden.bif
# echo "{" >> output-golden.bif
# echo "[bootloader]$home_dir/images/linux/zynq_fsbl.elf" >> output-golden.bif
# echo "$home_dir/images/linux/u-boot.elf" >> output-golden.bif
# echo "}" >> output-golden.bif
# echo "Generating BOOT-GOLDEN.BIN"
# $home_dir/bootgen/bin/bootgen -image output-golden.bif -o $home_dir/build/linux/BOOT-GOLDEN.BIN -w on

bit_file=`ls $home_dir/subsystems/linux/hw-description | grep .bit`
echo "Bit file name is $bit_file"
echo "the_ROM_image:" > $home_dir/output.bif
echo "{" >> $home_dir/output.bif
echo "[bootloader]$home_dir/images/linux/zynq_fsbl.elf" >> $home_dir/output.bif
#echo "/home/vutt6/Workspace/eila/fpga/capNLog/capNLog.runs/impl_1/capNLogSys_wrapper.bit" >> $home_dir/output.bif
echo "$home_dir/subsystems/linux/hw-description/$bit_file" >> $home_dir/output.bif 
echo "$home_dir/images/linux/u-boot.elf" >> $home_dir/output.bif
# echo "$home_dir/components/apps/rru/dpd_amp.elf" >> output.bif
# echo "[offset = 0xe80000]${home_dir}/build/linux/BOOT-GOLDEN.BIN" >> output.bif
echo "}" >> $home_dir/output.bif

echo "Generating BOOT.BIN"
$home_dir/bootgen/bin/bootgen -image  $home_dir/output.bif -o $home_dir/images/linux/BOOT.BIN -w on
cp $home_dir/images/linux/BOOT.BIN /tftpboot/BOOT.BIN

# echo "Coping release.txt to output"
# cp $home_dir/build/linux/rootfs/apps/rru/release.txt $home_dir/images/linux/release.txt
