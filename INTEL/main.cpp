#include <iostream>
#include <fstream>
#include "f.hpp"

#define HEADER_BUFF_SIZE 26
#define OFFSET_LOC 10
#define X_LOC 18
#define Y_LOC 22

char *g_pBuffer=nullptr;
uint32_t X,Y;
char header_buffer[HEADER_BUFF_SIZE];



constexpr uint32_t read4ByteBuff(char buffer[4])
{
    uint32_t r=buffer[3];
    r=r*256+buffer[2];
    r=r*256+buffer[1];
    r=r*256+buffer[0];
    return r;
}

using namespace std;

int main(int argc, char *argv[])
{
    std::ifstream input_image;
    input_image.open("in.bmp");
    input_image.read(header_buffer,HEADER_BUFF_SIZE);


//READ VALUES
    uint32_t size=read4ByteBuff(header_buffer+2);
    cout<<"Size: "<< size <<endl;
    uint32_t offset=read4ByteBuff(header_buffer+OFFSET_LOC);
    cout<<"Offset: "<< offset<<endl;
    X=read4ByteBuff(header_buffer+X_LOC);
    cout<<"X: "<< X<<endl;
    Y=read4ByteBuff(header_buffer+Y_LOC);
    cout<<"Y: "<< Y<<endl;
//READ PIXEL ARRAY
    g_pBuffer = new char [size-offset];
    input_image.read(g_pBuffer,offset-HEADER_BUFF_SIZE);
    input_image.read(g_pBuffer,size-offset);
//use function
    f(g_pBuffer,X,Y);

//Load header for new file
    input_image.close();
    input_image.open("in.bmp");
    char *header=new char [offset];
    input_image.read(header,offset);
    input_image.close();
//Save output file
    ofstream output_image;
    output_image.open("out.bmp");
    output_image.write(header,offset);
    output_image.write(g_pBuffer,size-offset);
    output_image.close();

    return 0;
}