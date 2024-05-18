/************************************************************************
  
Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
  
www.maven-silicon.com 
  
All Rights Reserved. 
This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd. 
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.
  
Filename		: 	ram_test.sv

Description 	: 	Test case for Dual port RAM
  
Author Name		: 	Putta Satish

Support e-mail	: 	For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

Version			:	1.0

************************************************************************/
//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------

// Extend ram_base_test from uvm_test;
class ram_base_test extends uvm_test;

   // Factory Registration
	`uvm_component_utils(ram_base_test)

  
    // Declare the ram_env and ram_wr_agent_config handles
    ram_env ram_envh;
    ram_wr_agent_config m_ram_cfg;
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "ram_base_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	
 endclass
//-----------------  constructor new method  -------------------//
// Define Constructor new() function
function ram_base_test::new(string name = "ram_base_test" , uvm_component parent);
	super.new(name,parent);
endfunction

//-----------------  build() phase method  -------------------//
            
function void ram_base_test::build_phase(uvm_phase phase);
	// Create the instance of config_object
    m_ram_cfg=ram_wr_agent_config::type_id::create("m_ram_cfg");
	// set is_active to UVM_ACTIVE 
    m_ram_cfg.is_active = UVM_ACTIVE;
    // set the config object into UVM config DB  
	uvm_config_db #(ram_wr_agent_config)::set(this,"*","ram_wr_agent_config",m_ram_cfg);
    super.build_phase(phase);
	// create the instance for env
	ram_envh=ram_env::type_id::create("ram_envh", this);
endfunction

//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------

   // Extend ram_seqr_arb_test from ram_base_test;
	class ram_seqr_arb_test extends ram_base_test;

  
   // Factory Registration
	`uvm_component_utils(ram_seqr_arb_test)

	
   // Declare the handle for all the write sequences
		
      
       ram_even_wr_xtns ram_even_seqh;
       ram_odd_wr_xtns ram_odd_seqh;
       ram_single_addr_wr_xtns ram_single_seqh;
	   ram_rand_wr_xtns ram_rand_seqh;
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "ram_seqr_arb_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern function void start_of_simulation_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
   	function ram_seqr_arb_test::new(string name = "ram_seqr_arb_test" , uvm_component parent);
		super.new(name,parent);
	endfunction


//-----------------  build() phase method  -------------------//
            
	function void ram_seqr_arb_test::build_phase(uvm_phase phase);
            super.build_phase(phase);
	endfunction
	
	function void ram_seqr_arb_test::end_of_elaboration_phase(uvm_phase phase);
// print the topology        
		uvm_top.print_topology();
	endfunction

	function void ram_seqr_arb_test::start_of_simulation_phase(uvm_phase phase);
	//set the sequencer arbitration to SEQ_ARB_RANDOM
         ram_envh.wr_agnth.seqrh.set_arbitration(SEQ_ARB_RANDOM);
	endfunction
//-----------------  run() phase method  -------------------//
      	task ram_seqr_arb_test::run_phase(uvm_phase phase);
		
		
		`uvm_info(get_type_name(), $sformatf("The current arbitration set is: %s",ram_envh.wr_agnth.seqrh.get_arbitration()),UVM_MEDIUM)		
		//raise objection
         phase.raise_objection(this);
		//create instance for sequences
          ram_single_seqh=ram_single_addr_wr_xtns::type_id::create("ram_single_seqh");
		  ram_rand_seqh=ram_rand_wr_xtns::type_id::create("ram_rand_seqh");
		  ram_even_seqh=ram_even_wr_xtns::type_id::create("ram_even_seqh");
		  ram_odd_seqh=ram_odd_wr_xtns::type_id::create("ram_odd_seqh");

		//start the sequences within fork join on agent sequencer as shown below by passing 
		//different values to the priority which is the 3rd argument of start method 
		  fork	
			ram_single_seqh.start(ram_envh.wr_agnth.seqrh,,100);
			ram_rand_seqh.start(ram_envh.wr_agnth.seqrh,,400);
			ram_odd_seqh.start(ram_envh.wr_agnth.seqrh,,300);
			ram_even_seqh.start(ram_envh.wr_agnth.seqrh,,400);
			
		 join	
		//drop objection
        phase.drop_objection(this);
	endtask    
