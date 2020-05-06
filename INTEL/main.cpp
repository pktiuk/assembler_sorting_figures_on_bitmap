#include <iostream>
#include <fstream>
#include <GL/glut.h>
#include <GL/freeglut.h>
#include "f.hpp"

#define HEADER_BUFF_SIZE 26
#define OFFSET_LOC 10
#define X_LOC 18
#define Y_LOC 22

char *g_pBuffer = nullptr;
char *t_pBuffer =nullptr;
uint32_t X, Y;
char header_buffer[HEADER_BUFF_SIZE];

using namespace std;

constexpr uint32_t read4ByteBuff(char buffer[4])
{
    uint32_t r = buffer[3];
    r = r * 256 + buffer[2];
    r = r * 256 + buffer[1];
    r = r * 256 + buffer[0];
    return r;
}

void describe_square(char *pointer)
{
    cout << " pole: " << int((*pointer)) << " xmin: " << int((*(pointer + 1))) << " xmax: " << int((*(pointer + 2)));
    cout << " ymin: " << int(*(pointer + 3)) << " ymax: " << int(*(pointer + 4));
}



void renderInLocation(float x, float y,char* pixbuff) {
    int viewport[4];
    glGetIntegerv(GL_VIEWPORT, viewport);
    glMatrixMode(GL_PROJECTION);
    glPushMatrix();
    glLoadIdentity();
    glOrtho(viewport[0], viewport[2], viewport[1], viewport[3], -1, 1);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glRasterPos2f(x, viewport[3] - y);
    glDrawPixels(X,Y,GL_RGBA,GL_UNSIGNED_BYTE,pixbuff);

    glMatrixMode( GL_PROJECTION );
    glPopMatrix();
    glMatrixMode( GL_MODELVIEW );   
    glPopMatrix();
}

void displayCb()
{
    //glDrawPixels(X,Y,GL_RGBA,GL_UNSIGNED_BYTE,g_pBuffer);
    renderInLocation(X,Y,g_pBuffer);
    renderInLocation(0,Y,t_pBuffer);
    glutSwapBuffers();
}


int main(int argc, char *argv[])
{
    std::ifstream input_image;
    string filename = "in.bmp";
    if (argc > 1)
    {
        filename = argv[1];
    }
    input_image.open(filename);

    input_image.read(header_buffer, HEADER_BUFF_SIZE);

    //READ VALUES
    uint32_t size = read4ByteBuff(header_buffer + 2);
    cout << "Size: " << size << endl;
    uint32_t offset = read4ByteBuff(header_buffer + OFFSET_LOC);
    cout << "Offset: " << offset << endl;
    X = read4ByteBuff(header_buffer + X_LOC);
    cout << "X: " << X << endl;
    Y = read4ByteBuff(header_buffer + Y_LOC);
    cout << "Y: " << Y << endl;
    //READ PIXEL ARRAY
    g_pBuffer = new char[size - offset];
    t_pBuffer = new char[size - offset];
    input_image.read(g_pBuffer, offset - HEADER_BUFF_SIZE);
    input_image.read(g_pBuffer, size - offset);
    for (unsigned int i = 0; i < size - offset; i++)
        t_pBuffer[i] = g_pBuffer[i];
    //use function
    f(t_pBuffer, g_pBuffer, X, Y);

    //print output
    cout << "\nFig 0 ";
    describe_square(t_pBuffer);
    cout << endl;
    cout << "\nFig 1 ";
    describe_square(t_pBuffer + 5);
    cout << endl;
    cout << "\nFig 2 ";
    describe_square(t_pBuffer + 10);
    cout << endl;
    cout << "\nFig 3 ";
    describe_square(t_pBuffer + 15);
    cout << endl;
    cout << "\nFig 4 ";
    describe_square(t_pBuffer + 20);
    cout << endl;

    //Load header for new file
    input_image.close();
    input_image.open(filename);
    char *header = new char[offset];
    input_image.read(header, offset);
    input_image.read(t_pBuffer, size - offset);
    input_image.close();
    //Save output file
    ofstream output_image;
    output_image.open("out.bmp");
    output_image.write(header, offset);
    output_image.write(g_pBuffer, size - offset);
    output_image.close();

    cout << "\nImage saved\n";

    glutInit(&argc,argv);
    glutInitDisplayMode(GLUT_SINGLE);
    glutInitWindowSize(X*2,Y);
    glutCreateWindow("Sorted and unsorted figures");
    glutDisplayFunc(displayCb);
    glutMainLoop();

    return 0;
}