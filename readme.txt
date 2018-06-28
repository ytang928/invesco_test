The project contains two parts. 

The first part is the Shiny app that plot the candlestick, find 5 peers with highest correlation and
calculate the pairwise correlation.
To run the code, 'cd' into the 'proj1' directory and run 'Rscript project1.R'. (Make sure shiny, dygraphs, xts and zoo packages are installed)

The second part contains two models for explaining contemporaneous return of the stocks. 
To access the part, 'cd' into the 'proj2' directory and run 'jupyter notebook method1.ipynb' / 'jupyter notebook method2.ipynb'



File structures:
- downloadData.py      - scripts for downloading bulks of stock data
- proj1
  - data               - supporting data
  - project1.R         - main App
  - demo.png           - a screenshot for the Shiny app 
- proj2
  - data               - supporting data
  - method1.ipynb      - Python Jupyter notebook file for Method 1
  - method2.ipynb      - Python Jupyter notebook file for Method 1


  @ Yuzhe Tang
  @ 2018.6.27