#include <EEPROM.h>

int addrCredentials = 0;
int i=0;

//We store the length of expected string
EEPROM.write(addrCredentials, cmd.length());
addrCredentials++;

//We browse the string and store each char
while(cmd[i] != '\0'){
      EEPROM.write(addrCredentials, cmd.substring(i,i+1);
      addrCredentials++;
      i++;
}
