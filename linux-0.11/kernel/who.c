#include <asm/segment.h>
#include <string.h>
#include <errno.h>

char g_name[60];

int iam(const char * name)
{
	int result;
	int cnt;

	printk("%s:%d\n", __func__, __LINE__);
	for(result = 0; get_fs_byte(name + result) != '\0'; result ++);

	if(result > 23) {
		return EINVAL;
	}

	for(cnt = 0; cnt < result; cnt ++) {
	printk("%s:%d\n", __func__, __LINE__);
		g_name[cnt] = get_fs_byte(name + cnt);
	printk("%s:%d c = %s\n", __func__, __LINE__, g_name[cnt]);
	}
	g_name[cnt + 1] = '\0';
	printk("%s:%d\n", __func__, __LINE__);

	printk("g_name = %s\n", g_name);

	return result;
}


int whoami(char* name, unsigned int size)
{
	int result;

	printk("%s:%d g_name = %s\n", __func__, __LINE__, g_name);
	if(size < strlen(g_name)) return EINVAL;
	printk("%s:%d\n", __func__, __LINE__);
	
	for(result = 0; g_name[result] != '\0'; result ++)
	{
	printk("%s:%d\n", __func__, __LINE__);
		put_fs_byte(g_name[result], &name[result]);
	printk("%s:%d\n", __func__, __LINE__);
	}
	printk("%s:%d\n", __func__, __LINE__);

	return result;
}
