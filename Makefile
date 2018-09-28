all: create_disk clean boot1 boot2 kernel write_boot1 write_boot2 write_kernel launch

create_disk:
	@dd if=/dev/zero of=disk.img bs=512 count=400

boot1:
	@nasm -f bin boot1.asm -o boot1.bin

boot2:
	@nasm -f bin boot2.asm -o boot2.bin

kernel:
	@nasm -f bin kernel.asm -o kernel.bin

write_boot1:
	@dd if=boot1.bin of=disk.img bs=512 seek=0 count=1 conv=notrunc

write_boot2:
	@dd if=boot2.bin of=disk.img bs=512 seek=1 count=20 conv=notrunc

write_kernel:
	@dd if=kernel.bin of=disk.img bs=512 seek=2 count=200 conv=notrunc

launch:
	@qemu-system-i386 -fda disk.img

clean:
	@rm -f *.bin disk.img *~
