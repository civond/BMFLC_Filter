<h1>BMFLC Filter Implementation</h1>
The weighted-frequency Fourier Linear Combiner (WFLC) is a nonlinear adaptive noise-cancelling algorithm for tremor. It performs fairly well for a single frequency present in a tremor signal. However, WFLC performance will degrade fro signals containing two or more similar frequencies, limiting its use.</br></br>

The band-limited multiple Fourier Linear Combiner (BMFLC) is an alternative to filter tremor signals that is based on the concepts of the WFLC algorithm. BMFLC is able to track multiple frequency components in an input signal as shown in the figures below.

<div>
    <img src='/Figures/layout.png' width='400px' style="text-align:center" ></img></br>
    <img src='/Figures/layout2.png' width='450px'></img></br>
</div></br>

<h2>Usage</h2>
In this code, I implement the BMFLC filter with an LMS algorithm to simulate tremor reduction in MATLAB. To use it, first enter the number of frequency components that you wish to estimate (N). If your signal contains noise, it is optimal to choose a high number (such as N=35, or 100). Next, there is a frequency step of 1.
<br/><br/>

Then, the code will create 3 2xN matrices to store weight values, estimate, and error and update/use these values as frequency increments upwards. It is important to remember that this filter will provide estimates of each N you define,and add them cumulatively together to create an estimate of the signal. Thus, we must extract our desired frequency components out of the estimate. As shown below, this outputs a signal with noise greatly reduced, and follows the clean signal.
<br/><br/>

<div>
    <img width="400px" src="/Figures/BMFLC.jpg"></img>
    <img width="400px" src="/Figures/zoom.jpg"></img>
</div>
