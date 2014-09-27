Convert Your Virtual Machine Image
==========================
- Create a new directory
- List all of your virtual machines
- Locate the target virtual machine block image
- Copy the block image in the new created directory 
- Save XML configurations of the virtual machine in the new created directory
- Convert virtual machine block image from “qcow2” to “vmdk”
- Convert virtual machine XML configurations from “virsh” to “virt-image”
- Convert configurations from “virt-image” to “VMX”
- Fix the new created VMX configuration in the “block image” element 

Example:
===============
- # mkdir new_dir
- # virsh -c qemu+ssh://root@192.168.10.133/system list –all
- # virsh -c qemu+ssh://root@192.168.10.133/system domblklist dspace
- # rsync -avzP root@192.168.10.133:/images/dspace.qcow2 new_dir/.
- # virsh -c qemu+ssh://root@192.168.10.133/system dumpxml dspace > new_dir/dspace.xml
- # qemu-img convert -O vmdk dspace.qcow2 dspace.vmdk -p
- # ./dom2img.py new_dir/dspace.xml
- # virt-convert -i virt-image new_dir/dspace.xml_converted -o vmx new_dir/dspace.vmx
- # sed -i -e 's/”/images/dspace.qcow2”/”dpsace.vmdk”/g' new_dir/dspace.vmx
