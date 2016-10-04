import unittest
import shutil
import numpy
import tempfile
import cdms2
import os


class CDMSBaseTest(unittest.TestCase):
    def getFile(self, path, mode="r"):
        f = cdms2.open(path, mode)
        self.files.append(f)
        return f

    def getTempFile(self, path, mode="r"):
        f = cdms2.open(os.path.join(self.tempdir, path), mode)
        self.files.append(f)
        return f

    def setUp(self):
        self.files = []
        self.NTIME = 3
        self.NLAT = 16
        self.NLON = 32
        self.test_arr = numpy.ma.arange(float(2 * self.NTIME * self.NLAT * self.NLON))
        self.test_arr.shape = (2, self.NTIME, self.NLAT, self.NLON)
        self.tempdir = tempfile.mkdtemp()

    def tearDown(self):
        for f in self.files:
            f.close()
        shutil.rmtree(self.tempdir)


def run():
    unittest.main()
