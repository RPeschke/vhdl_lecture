# IDLAB VHDL Lecture

## Old lectures 
[VHDL](VHDL/readme.md)


## Python based HDL 
[ARGG HDL](argg_hdl/readme.md)


## Session 08 

In this lecture we want to learn how to use argg_hdl to make firmware design. First you have to download the library. For this you can just clone the repository and then run the install script which should install the library to your python istallation. 



```bash
git clone https://github.com/RPeschke/argg_hdl.git
cd argg_hdl
./install_dist.sh
```

After this is done the ARGG_HDL library will be part of you python istallation. You can uses its functionallity from anywhere. You dont have to be in the argg_hdl folder.

In order to check this go back to the vhdl_lecture folder and run the following python file:

```bash 
./session_08/fifo.py
```

The main objective for this lecture is to build a ram module from the scratch. 


Before we do anything we should think about how to use it. What API it should have. Our memory block should work like an ordenary array. Therefore we want to able to do two thinks.

- set data 
- get data 

So our interface should only have two functions (for now)

```python
ram = ramBlock(100)
...

ram.setData(Addr, dataIn)
ram.getData(Addr, DataOut) 

```

In general we cannot assume that the ram object is ready to receive data nor that we will get the data imidiatly. Therefore we have to think about how to handle these case. Lets for now ignore the writing to the data and focus only on reading data back. We cannot be sure that we will get the data on the same clock cycle that we have requested the data. Therefore we have the option to divide "request data", "Has Data" and "read data" into three seperate function or we can use the newly discribed optional_t to handle this for us. 




