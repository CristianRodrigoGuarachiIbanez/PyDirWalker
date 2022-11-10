from OpenCVModuls cimport *
from libcpp.string cimport string
from libcpp.vector cimport vector

cdef extern from "../../directoryWalker/dirWalker.h" namespace "DirectoryWalker":
    cdef cppclass DirWalker:
        #public
        DirWalker(string path, string type, int extention) except +
        vector[Mat] images()
        vector[string] directories()
        vector[string] selectedDirectories()
          
        #private:
        vector[string] listOfDirs
        vector[string] selectedDirs
        vector [Mat] listOfImages
        void directorieswalker(string path, string type, int extention)
        inline Mat openImage(string fileName)