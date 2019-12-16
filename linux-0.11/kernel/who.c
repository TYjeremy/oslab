#include <asm/segment.h>
#include <errno.h>

char g_name[24];

int iam(const char * name)
{
	int result;
	int cnt;

	for(result = 0; get_fs_byte(name + result) != '\0'; result ++);

	if(result > 23) {
		return EINVAL;
	}

	for(cnt = 0; cnt < result; cnt ++) {
		g_name[cnt] = get_fs_byte(name + cnt);
	}
	g_name[cnt + 1] = '\0';

	return result;
}


int whoami(char* name, unsigned int size)
{
	int result;

	if(size < strlen(g_name)) return EINVAL;
	
	for(result = 0; get_fs_byte(name + result) != '\0'; result ++)
	{
		put_fs_byte(g_name[result], name[result]);
	}

	return result
}
