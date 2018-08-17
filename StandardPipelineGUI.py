#!/Python-3.6.5 python
import tkinter as tk
from tkinter import filedialog

import os
abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname)
rpath = dname + "\\R-3.4.0\\bin\\i386\\Rscript"
envpath = dname + "\\R-3.4.0\\etc"


class Application(tk.Frame):

    def __init__(self, master=None):
        tk.Frame.__init__(self,master)
        self.grid()
        # self.grid(sticky=tk.N+tk.S+tk.E+tk.W)
        # self.createWidgets()
        self.choosedir()

    def choosedir(self):
        top = self.winfo_toplevel()
        top.rowconfigure(0, weight=1)
        top.columnconfigure(0, weight=1)
        self.rowconfigure(0, weight=1)
        self.columnconfigure(0, weight=1)

        self.LFQ = tk.IntVar()
        self.Intensity = tk.IntVar()
        self.MedianCentre = tk.IntVar()
        self.Quantile = tk.IntVar()

        self.checkFrame = tk.LabelFrame(self, text='1. Select Quantitation Type', padx=10, pady=0, width=50, height=25). \
            grid(row=0, columnspan=2, padx=0, pady=0, sticky=tk.N + tk.S + tk.E + tk.W)

        self.checkFrame = tk.LabelFrame(self, text='2. Select Normalisation Type (usually for Intensity Quant)',
                                        padx=10, pady=0, width=50, height=25). \
            grid(row=1, columnspan=2, padx=0, pady=0, sticky=tk.N + tk.S + tk.E + tk.W)

        self.fileFrame = tk.LabelFrame(self, text='3. Select txt file directory and import data files', padx=10, pady=0, width=50,
                                       height=80). \
            grid(row=2, columnspan=2, padx=0, pady=0, sticky=tk.N + tk.S + tk.E + tk.W)

        self.runFrame = tk.LabelFrame(self, text='4. Run Analysis', padx=10, pady=0, width=50, height=10). \
            grid(row=3, columnspan=3, padx=0, pady=0, sticky=tk.N + tk.S + tk.E + tk.W)

        self.LFQ = tk.Checkbutton(self, text='LFQ', variable=self.LFQ)
        self.Intensity = tk.Checkbutton(self, text='Intensity', variable=self.Intensity)
        self.Intensity.config(state="active")
        self.Intensity.select()

        self.MedianCentre = tk.Checkbutton(self, text='Median Centre', variable=self.MedianCentre)
        self.MedianCentre.config(state="active")
        self.MedianCentre.select()
        self.Quantile = tk.Checkbutton(self, text='Quantile', variable=self.Quantile)
        self.Quantile.config(state="disabled")


        # self.FullReport.select()
        self.DirButton = tk.Button(self, text='Pick txt directory of MQ run',
                                    command=self.directoryOpen)
        self.note = tk.Label(self, text="Note: Please copy mqpar.xml file into txt folder before selecting folder",
                             font=("TkDefaultFont ", 8, "italic"), fg="red")

        self.StartButton = tk.Button(self, text='Start Analysis!', bg = "green", fg = "white",
                                     command=self.ExecuteNormalise)

        self.quitButton = tk.Button(self, text='Quit', bg = "red", fg = "white",
                                        command=self.quit)

        self.version = tk.Label(self, text = "Brandon Murugan | 2018 | v1.0", font=("TkDefaultFont ", 8))

        self.LFQ.grid(row=0, column=0, padx=20, pady=20)#, sticky=tk.N + tk.S + tk.E + tk.W)
        self.Intensity.grid(row=0, column=1, padx=20, pady=20)#, sticky=tk.N + tk.S + tk.E + tk.W)

        self.MedianCentre.grid(row=1, column=0, padx=20, pady=20)#, sticky=tk.N + tk.S + tk.E + tk.W)
        self.Quantile.grid(row=1, column=1, padx=20, pady=20)#, sticky=tk.N + tk.S + tk.E + tk.W)

        self.DirButton.grid(row=2, column=1,padx=5, pady=20, sticky=tk.N)
        self.note.grid(row=2, column=1,padx=5, pady=5, sticky=tk.S)

        self.StartButton.grid(row=3, column=1,padx=5, pady=20, sticky=tk.N + tk.S + tk.E + tk.W)

        self.quitButton.grid(row=4, column=2, columnspan=20, padx=5, pady=20, sticky=tk.N + tk.S + tk.E + tk.W)

        self.version.grid(row=4, column=0, columnspan=1, padx=0, pady=0, sticky=tk.S + tk.W)
        # self.version.pack(anchor=tk.E, pady=(0, 25))

    def ExecuteNormalise(self):
        # calls RunSummary.R, tells python to wait on the returncode from that subprocess call, then removes temp
        # folder including the summary settings file that has the path in it
        import subprocess
        import shutil
        self.rPreprocessCall = subprocess.Popen([rpath, ".\\2_dataPreprocess.R"], shell=True)

        # INSERT OPTION FOR DELETING TEMP IMAGE FILES ALSO
        # self.rscriptcall.wait()
        # shutil.rmtree(self.tempPath)
        # self.bell()

    def directoryOpen(self):
        # gets directory at users prompt, and writes directory, as well as report type choices to txt file and stores
        # it in temp folder of the script home location
        self.directory = tk.filedialog.askdirectory(initialdir='C:\\')
        summarySettings = ["PATH", "\t", self.directory, "\n", "LFQ","\t", self.LFQ.get(),"\n",
                           "Intensity","\t", self.Intensity.get()]
        self.tempPath = dname + "/temp"
        if not os.path.exists(self.tempPath):
            os.makedirs(self.tempPath)
        self.summaryfilepath = self.tempPath + "/summarySettings.txt"
        with open(self.summaryfilepath, "w") as file:
            for s in summarySettings:
                file.write(str(s))

        import subprocess
        import shutil
        self.rImportCall = subprocess.Popen([rpath, ".\\1_dataImport.R"], shell=True)

        # checks if selectedpath/images exists. if not, it gets created
        self.imagepath = self.directory + "/images"
        if not os.path.exists(self.imagepath):
            os.makedirs(self.imagepath)

        

app = Application()
app.master.title('MaxQuant Advanced Summary')
app.mainloop()
