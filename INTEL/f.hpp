#ifndef F_HPP_
#define F_HPP_

extern "C"{
    /**
     * @brief function sorting figures on image from ste smallest to the biggest
     * 
     * @param tmp_buffer -buffer as big as pbuffer
     * @param pbuffer -contains image
     * @param x -width of image
     * @param y -height of image
     */
    void f(char *tmp_buffer,char *pbuffer, int x, int y);
}



#endif // F_HPP_