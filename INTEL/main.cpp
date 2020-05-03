#include <iostream>
#include <fstream>
#include <GL/glut.h> 
#include "f.hpp"


unsigned char *g_pBuffer=nullptr;
uint32_t X,Y;
char header_buffer[26];

void displayCallback()
{
    glDrawPixels(Y,X,GL_RGBA,GL_UNSIGNED_BYTE,g_pBuffer);
    glutSwapBuffers();
}

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
    input_image.read(header_buffer,26);
    uint32_t size=read4ByteBuff(header_buffer+2);
    cout<<"Size: "<< size <<endl;
    uint32_t offset=read4ByteBuff(header_buffer+10);
    cout<<"Offset: "<< offset<<endl;
    X=read4ByteBuff(header_buffer+18);
    cout<<"X: "<< X<<endl;
    Y=read4ByteBuff(header_buffer+22);
    cout<<"Y: "<< Y<<endl;

    //X=10;
    //Y=10;
    //g_pBuffer = new unsigned char [X*Y*4];
    //glutInit(&argc,argv);
    //glutInitDisplayMode(GLUT_SINGLE);
    //glutInitWindowPosition(100,100);
    //glutCreateWindow("Window");
    //glutDisplayFunc(displayCallback);
    //glutMainLoop();


    return 0;
}