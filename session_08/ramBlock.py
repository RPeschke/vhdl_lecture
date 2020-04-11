
from argg_hdl import *
import argg_hdl.examples as  ahe



class ramHandle(v_class_master):
    def __init__(self):
        super().__init__()
        self.content = v_variable(v_list(v_slv(32),100))
        

    def set_data(self, addr, data):
        self.content[addr] << data

    def get_data(self, addr, data):
        data.reset()
        data << self.content[addr] 


class ramBlock(v_entity):
    def __init__(self):
        super().__init__()
        self.clk = port_in(v_sl())
        self.we  = port_in(v_sl())
        self.wAddr = port_in(v_slv(32))
        self.wData = port_in(v_slv(32))

        self.ReadData = port_out(v_slv(32))
        self.ReadAddr = port_in(v_slv(32))

        self.architecture()
    
    @architecture
    def architecture(self):
        content = v_signal(v_list(v_slv(32),100))

        @rising_edge(self.clk)
        def proc():
            if self.we:
                content[self.wAddr] << self.wData

            self.ReadData   << content[self.ReadAddr]     
        
        end_architecture()

class clk_gen(v_entity):
    def __init__(self):
        super().__init__()
        self.clk = port_out( v_sl())


        self.architecture()


    @architecture
    def architecture(self):       
        @timed()
        def proc():
            self.clk << 1
            yield wait_for(10)
            self.clk << 0 
            yield wait_for(10)

class ram_block_tb(v_entity):
    def __init__(self):
        super().__init__()

        self.architecture()


    @architecture
    def architecture(self):
        
        clkg = v_create(clk_gen())
        
        ramH = ramHandle()
        ramB = v_create(ramBlock())
        ramB.clk << clkg.clk

        count = v_slv(32)
        @rising_edge( clkg.clk)
        def proc():
            count << count +1

        
        counter2 = v_copy(count)

        @rising_edge( clkg.clk)
        def proc1():
            
            if count > 10:
                ramH.set_data(counter2, count)
                counter2 << counter2+1
            if counter2 > 90:
                counter2 << 0



        counter3 = v_copy(count)
        addrCounter = v_slv(32)
        dataOut = v_slv(32)

        @rising_edge(clkg.clk)
        def proc2():
            ramB.we <<0
            if count > 10:
                ramB.we << 1
                ramB.wAddr <<  counter2
                ramB.wData <<  count
                counter3 << counter3+1
            if counter3 > 90:
                counter3 << 0

            if counter3 > 50:
                ramB.ReadAddr << addrCounter
                addrCounter << addrCounter +1 
                dataOut << ramB.ReadData
            
            if addrCounter > 90:
                addrCounter << 0
 


        end_architecture()

ram123 = ramHandle()
t1 = v_create(ram_block_tb())

#run_simulation(t1,3000, "ramHandler.vcd")


convert_to_hdl(t1,"session_08/ram/")