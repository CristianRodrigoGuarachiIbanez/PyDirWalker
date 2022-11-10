from PyDirWalker.PyDirectoryWalker import PyDirWalker
from unittest import TestCase


class TestPyDirWalker:
    def reset(self):
        self._dirWalker = PyDirWalker(b"./", b"", 4)
        self._testDirs()

    def _testDirs(self):
        self._dirs =  self._dirWalker.directories()
        self._imgs = self._dirWalker.images()

    def testSelectedDirectories(self):        
        assert len(self._dirs) > 0 and len(self._imgs) == 0
    
    def testListOfDirs(self): 
        assert len(self._dirs) > 0 and len(self._imgs) == 0

    def testListOfImages(self):
        assert len(self._dirs) > 0 and len(self._imgs) == 0