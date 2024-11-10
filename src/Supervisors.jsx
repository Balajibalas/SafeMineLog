import React, { useState, useEffect, useCallback } from 'react';
import { supabase } from './CreateClient';
import './App.css'

function Supervisors() {
  const [users, setUsers] = useState([]);
  const [user, setUser] = useState({
    supervisor_name: '',
    phone_number: '',
    email: ''
  });

  const [user2, setUser2] = useState({
    id: '',
    supervisor_name: '',
    phone_number: '',
    email: ''
  });

  console.log(user);

  useEffect(() => {
    fetchUsers();
  }, []);

  // Fetch supervisors and their shifts
  async function fetchUsers() {
    // Fetch supervisors from the 'All_supervisor' table
    const { data: allSupervisors, error: supervisorError } = await supabase
      .from('All_supervisor')
      .select('*')
      .order('id', { ascending: true });

    if (supervisorError) {
      console.error("Error fetching supervisors:", supervisorError);
      return;
    }

    // Fetch all shifts from the 'Supervisor_shift' table
    const { data: supervisorShifts, error: shiftError } = await supabase
      .from('Supervisor_shift')
      .select('*');

    if (shiftError) {
      console.error("Error fetching supervisor shifts:", shiftError);
      return;
    }

    // Create a map of shifts by supervisor ID
    const shiftMap = supervisorShifts.reduce((map, shift) => {
      map[shift.id] = shift.Mon; // Assuming the shift for all days is the same, so using 'Mon'
      return map;
    }, {});

    // Combine supervisor data with their shifts
    const supervisorsWithShifts = allSupervisors.map(supervisor => ({
      ...supervisor,
      shift: shiftMap[supervisor.id] || "Not Assigned" // Set "Not Assigned" if no shift is found
    }));

    setUsers(supervisorsWithShifts); // Update state with combined data
  }

  // Handle form input changes
  function handleChange(event) {
    setUser(prevFormData => ({
      ...prevFormData,
      [event.target.name]: event.target.value
    }));
  }

  function handleChange2(event) {
    setUser2(prevFormData => ({
      ...prevFormData,
      [event.target.name]: event.target.value
    }));
  }

  // Create new supervisor
  async function createUser(event) {
    event.preventDefault();
    try {
      await supabase.from('All_supervisor').insert({ 
        supervisor_name: user.supervisor_name, 
        phone_number: user.phone_number, 
        email: user.email 
      });
      fetchUsers();
    } catch (error) {
      console.error(error);
    }
  }

  // Delete a supervisor
  async function deleteUser(userId) {
    await supabase.from('All_supervisor').delete().eq('id', userId);
    fetchUsers();
  }

  // Handle shift allotment
  // Handle shift allotment
async function shiftAllotment() {
  let shifts = ["A", "B", "C"]; // List of shifts
  let i = 0;

  for (const user of users) {
    // Check if supervisor is present in the Supervisor_shift table
    const { data: existingShift, error } = await supabase
      .from('Supervisor_shift')
      .select('*')
      .eq('id', user.id);

    if (error) {
      console.error("Error fetching shift:", error);
      continue;
    }

    // Determine the shift to assign using round-robin logic
    const assignedShift = shifts[i % shifts.length];

    // If shift exists, update it
    if (existingShift && existingShift.length > 0) {
      await supabase
        .from('Supervisor_shift')
        .update({ 
          Mon: assignedShift, 
          Tue: assignedShift, 
          Wed: assignedShift, 
          Thu: assignedShift, 
          Fri: assignedShift, 
          Sat: assignedShift 
        })
        .eq('id', user.id);
    } else {
      // If not present, insert a new shift entry
      await supabase
        .from('Supervisor_shift')
        .insert({ 
          id: user.id, 
          Mon: assignedShift, 
          Tue: assignedShift, 
          Wed: assignedShift, 
          Thu: assignedShift, 
          Fri: assignedShift, 
          Sat: assignedShift 
        });
    }

    // Move to the next shift in the list for the next supervisor
    i++;
  }

  fetchUsers(); // Refresh after shift allotment
}

  // Display selected user's details
  function displayUser(userId) {
    users.forEach(user => {
      if (user.id === userId) {
        setUser2({ 
          id: user.id, 
          supervisor_name: user.supervisor_name, 
          phone_number: user.phone_number, 
          email: user.email 
        });
      }
    });
  }

  // Update existing supervisor details
  const updateUser = useCallback(async (userId) => {
    await supabase
      .from('All_supervisor')
      .update({ 
        supervisor_name: user2.supervisor_name, 
        phone_number: user2.phone_number, 
        email: user2.email 
      })
      .eq('id', userId);

    fetchUsers();
  }, [user2]);

  return (
    <div>
      <header>
        <h2>Supervisors Management</h2>
      </header>
      
      <h5>Add New Supervisor</h5>
      <form onSubmit={createUser}>
        <input
          type='text'
          placeholder='Supervisor Name'
          name='supervisor_name'
          onChange={handleChange}
        />
        <input
          type='number'
          placeholder='Phone Number'
          name='phone_number'
          onChange={handleChange}
        />
        <input
          type='email'
          placeholder='Email'
          name='email'
          onChange={handleChange}
        />
        <button type='submit' className="btn btn-success add">Create</button>
      </form>

      <h5>Update an Existing Supervisor</h5>
      <form onSubmit={(e) => {
        e.preventDefault();
        updateUser(user2.id);
      }}>
        <input
          type='text'
          defaultValue={user2.supervisor_name}
          name='supervisor_name'
          onChange={handleChange2}
        />
        <input
          type='text'
          defaultValue={user2.phone_number}
          name='phone_number'
          onChange={handleChange2}
        />
        <input
          type='text'
          defaultValue={user2.email}
          name='email'
          onChange={handleChange2}
        />
        <button type="submit" className="btn btn-primary">Save</button>
      </form>

      <br></br>
      <button className="btn btn-info shift-allotment" onClick={shiftAllotment}>Shift Allotment</button>
      
      <table>
        <thead>
          <tr>
            <th>Id</th>
            <th>Supervisor Name</th>
            <th>Phone Number</th>
            <th>Email</th>
            <th>Shift</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {users.map((user) => (
            <tr key={user.id}>
              <td>{user.id}</td>
              <td>{user.supervisor_name}</td>
              <td>{user.phone_number}</td>
              <td>{user.email}</td>
              <td>{user.shift}</td> {/* Show the shift */}
              <td>
                <button 
                  type="button" 
                  className="btn btn-primary mv" 
                  onClick={() => {
                    setUser2({ id: '', supervisor_name: '', phone_number: '', email: '' }); // Reset user2 state
                    displayUser(user.id);
                  }}>
                  Edit
                </button>
                <button 
                  type="button" 
                  className="btn btn-danger mv" 
                  onClick={() => { deleteUser(user.id) }}>
                  Delete
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default Supervisors;
