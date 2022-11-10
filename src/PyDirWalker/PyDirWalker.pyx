
from lib.PyDirWalker cimport *
from libc.stdlib cimport free
from numpy import ndarray, dstack, asarray, float32, uint8
from cython cimport boundscheck, wraparound

cdef class PyDirWalker:
    cdef:
        DirWalker * _dirWalker
        vector[string] _dirs
        vector[Mat] _images
        string type
    
    def __cinit__(self, string path, string type, int extension):
        self._dirWalker = new DirWalker(path, type, extension)
        self.type = type
    
    def __dealloc__(self):
        free(self._dirWalker)
    
    
    @boundscheck(False)
    @wraparound(False)
    cdef void walkThroughDirectory(self):
        if self.type.empty():
            self._dirs = self._dirWalker.directories()
        
        elif self.type == ".png" or self.type == ".jpg":
            self._images = self._dirWalker.images()
            
        else:
            self._dirs = self._dirWalker.selectedDirectories()

    
    @boundscheck(False)
    @wraparound(False)
    cdef list getImages(self):
        cdef: 
            int i, size
        self.walkThroughDirectory()
        output = []
        size = self._images.size()
        if size > 0:
            for i in range(size):
                output.append(self.Mat2np(self._images[i]))
        return output
    
    
    @boundscheck(False)
    @wraparound(False)
    cdef list getDirs(self):
        cdef:
            int i, size
        self.walkThroughDirectory()
        output = []
        size = self._dirs.size()
        if size > 0:
            for i in range(size):
                output.append(self._dirs[i])
        return output


    @boundscheck(False)
    @wraparound(False)
    cdef inline object Mat2np(self, Mat m):
        # Create buffer to transfer data from m.data
        cdef Py_buffer buf_info

        # Define the size / len of data
        cdef size_t len = m.rows*m.cols*m.elemSize() # m.channels()*sizeof(CV_8UC3)

        # Fill buffer
        PyBuffer_FillInfo(&buf_info, NULL, m.data, len, 1, PyBUF_FULL_RO)

        # Get Pyobject from buffer data
        Pydata  = PyMemoryView_FromBuffer(&buf_info)

        # Create ndarray with data
        # the dimension of the output array is 2 if the image is grayscale
        if m.channels() >1 :
            shape_array = (m.rows, m.cols, m.channels())
        else:
            shape_array = (m.rows, m.cols)

        if m.depth() == CV_32F :
            ary = ndarray(shape=shape_array, buffer=Pydata, order='c', dtype=float32)
        else :
            #8-bit image
            ary = ndarray(shape=shape_array, buffer=Pydata, order='c', dtype=uint8)

        if m.channels() == 3:
            # BGR -> RGB
            ary = dstack((ary[...,2], ary[...,1], ary[...,0]))

        # Convert to numpy array
        pyarr = asarray(ary)
        return pyarr


    def images(self):
        return self.getImages()
    
    def directories(self):
        return self.getDirs()