# Unmixing GUI

This is a MATLAB graphical user interface for performing linear unmixing on multispectral images. 

## Contributors

- [Zachary T. Harmany](http://drz.ac), PhD, Department of Pathology and Laboratory Medicine, UC Davis Medical Center. (ztharmany@ucdavis.edu)

- Nenad Bozinovic (nesaboz@gmail.com)

## Development Notes

On branch `dump`, the main file to load for the GUI is `main33_w_ASE_toRCA.m`. Within the function `main33_w_ASE_toRCA_OpeningFcn`, I added a line to add `../DyCE/` to the path so that the GUI can find the `RcaFunction.m` code within that directory. Then I committed everyting into the `dump` branch in Git.

