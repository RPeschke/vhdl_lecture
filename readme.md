# IDLAB VHDL Lecture

## Old lectures 
[VHDL](VHDL/readme.md)


## Python-based HDL 
[ARGG HDL](argg_hdl/readme.md)


## Session 08 

In this lecture we want to learn how to use argg_hdl to make firmware design. First you have to download the library. For this you can just clone the repository and then run the install script which should install the library to your python installation. 



```bash
git clone https://github.com/RPeschke/argg_hdl.git
cd argg_hdl
./install_dist.sh
```

After this is done the ARGG_HDL library will be part of you python installation. You can uses its functionality from anywhere. You don't have to be in the argg_hdl folder.

In order to check this go back to the vhdl_lecture folder and run the following python file:

```bash 
./session_08/fifo.py
```

The main objective for this lecture is to build a ram module from scratch. 


Before we do anything we should think about how to use it. What API it should have. Our memory block should work like an ordinary array. Therefore we want to able to do two thinks.

- set data 
- get data 

So our interface should only have two functions (for now)

```python
ram = ramBlock(100)
...

ram.setData(Addr, dataIn)
ram.getData(Addr, DataOut) 

```

In general we cannot assume that the ram object is ready to receive data nor that we will get the data immediately. Therefore we have to think about how to handle this case. Lets for now ignore the writing to the data and focus only on reading data back. We cannot be sure that we will get the data on the same clock cycle that we have requested the data. Therefore we have the option to divide "request data", "Has Data" and "read data" into three separate functions or we can use the newly described optional_t to handle this for us. 


## Session 09 Test-Driven Development

![TDD](doc_TDD//Slide1.png)

Test-driven development describes a set of tools/techniques to ensure the correctness of a program over its lifetime. Large Programs that exist for a long time are usually to complex for one programmer to know all the parts. Even if the program was only written by one person. Futur me and past me are not the same person. This means that in order to maintain the correctness of the program, programmers need a way to quantify correctness in some way. 

For this programmers have developt techniques to quantify if a program is correct or not. This is done by using "automated tests". Which is a fancy word of saying you have a program from which you know exactly what its output is supposed to be. 

Let's have a look at an example from python:

```python 
import unittest

class TestStringMethods(unittest.TestCase):

    def test_upper(self):
        self.assertEqual('foo'.upper(), 'FOO')

    def test_isupper(self):
        self.assertTrue('FOO'.isupper())
        self.assertFalse('Foo'.isupper())

    def test_split(self):
        s = 'hello world'
        self.assertEqual(s.split(), ['hello', 'world'])
        # check that s.split fails when the separator is not a string
        with self.assertRaises(TypeError):
            s.split(2)

if __name__ == '__main__':
    unittest.main()
```

This example checks if the string operations are performed correctly. It is a very simple example but it already shows the basics. Let's have a look at the first example.  

```python 

    def test_upper(self):
        self.assertEqual('foo'.upper(), 'FOO')

```

It checks that the Memberfunction `upper` returns the correct string. It is important to note that the input to the function as well as the reference are fixed objects. 


In short, a test-case is a small program which processes a fixed input and compares it to a fixed reference output. 

This Technique is used to ensure that the program does not change behavior due to refactoring or adding new features. 

In modern programming, each new feature starts with a new test-case.





![TDD](doc_TDD//Slide2.png)


![TDD](doc_TDD//Slide3.png)

![TDD](doc_TDD//Slide4.png)
![TDD](doc_TDD//Slide5.png)
![TDD](doc_TDD//Slide6.png)
![TDD](doc_TDD//Slide7.png)
![TDD](doc_TDD//Slide8.png)
![TDD](doc_TDD//Slide9.png)
![TDD](doc_TDD//Slide10.png)
![TDD](doc_TDD//Slide11.png)
![TDD](doc_TDD//Slide12.png)
