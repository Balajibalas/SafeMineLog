import React, { useState, useEffect, useCallback } from 'react';
import { supabase } from './CreateClient';
import './App.css'
import moment from 'moment';

function CurrentWorkers() {
  const [users, setUsers] = useState([]);
  const [user, setUser] = useState({
    id: '',
    timestamp: ''
  });

  useEffect(() => {
    fetchUsers();
  }, []);

  async function fetchUsers() {
    const { data } = await supabase.from('Curr_Workers').select('*').order('id', { ascending: true });
    setUsers(data);
  }

  function handleChange(event) {
    setUser(prevFormData => {
      return {
        ...prevFormData,
        [event.target.name]: event.target.value
      }
    });
  }


  async function createUser(event) {
    event.preventDefault();
    try {
      const timestamp = moment().format('YYYY-MM-DD HH:mm:ss');
      await supabase.from('Curr_Workers').insert({ id: user.id, timestamp: timestamp });
      fetchUsers();
    } catch (error) {
      console.error(error);
      // Handle the error properly, e.g., display an error message to the user
    }
  }

  async function deleteUser(userId) {
    await supabase.from('Curr_Workers').delete().eq('id', userId);
    fetchUsers();
  }


  function displayTimestamp(timestamp) {
    return moment(timestamp).format('YYYY-MM-DD HH:mm:ss');
  }

  return (
    <div>
      <header>
        <h2>Current Workers Management</h2>
      </header>
      <h5>Add New Worker</h5>
      <form onSubmit={createUser}>
        <input
          type='number'
          placeholder='worker id'
          name='id'
          onChange={handleChange}
          value={user.id}
        />
        <button type='submit' className="btn btn-success add">Create</button>
      </form>
      <table>
        <thead>
          <tr>
            <th>Id</th>
            <th>Timestamp</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {users && users.map((user) => (
            <tr key={user.id}>
              <td>{user.id}</td>
              <td>{displayTimestamp(user.timestamp)}</td>
              <td>
                <button type="button" className="btn btn-danger mv" onClick={() => deleteUser(user.id)}>Delete</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default CurrentWorkers;