import React,{} from 'react';
import { BrowserRouter, Route, Routes, NavLink } from 'react-router-dom';
import Workers from './workers';
import Supervisors from './Supervisors';
import CurrentWorkers from './currentworkers';

function App() {

  return (
    <BrowserRouter>
      <div
        style={{
          height: '100vh',
          width: '100vw',
          display: 'flex',
          flexDirection: 'column',
        }}
      >
        <nav
          style={{
            backgroundColor: '#333',
            color: '#fff',
            padding: 20,
            display: 'flex',
            justifyContent: 'space-between',
          }}
        >
          <h2>Main Page</h2>
          <ul
            style={{
              listStyle: 'none',
              padding: 0,
              margin: 0,
              display: 'flex',
            }}
          >
            <li style={{ marginRight: 20 }}>
              <NavLink to="/" style={{ textDecoration: 'none', color: '#fff', fontSize:25}}>
                Home
              </NavLink>
            </li>
            <li style={{ marginRight: 20 }}>
              <NavLink to="/workers" style={{ textDecoration: 'none', color: '#fff', fontSize:25 }}>
                Workers
              </NavLink>
            </li>
            <li style={{ marginRight: 20 }}>
              <NavLink to="/Supervisors" style={{ textDecoration: 'none', color: '#fff' ,fontSize:25}}>
                Supervisors
              </NavLink>
            </li>
            <li>
              <NavLink to="/currentworkers" style={{ textDecoration: 'none', color: '#fff' ,fontSize:25}}>
                Current Workers
              </NavLink>
            </li>
          </ul>
        </nav>
        <div
          style={{
            flex: 1,
            padding: 20,
          }}
        >
          <Routes>
            <Route
              path="/"
              element={
                <div
                  style={{
                    backgroundColor: '#3498db', // blue background
                    height: '100%',
                    width: '100%',
                    display: 'flex',
                    justifyContent: 'center',
                    alignItems: 'center',
                  }}
                >
                  <h1>Welcome to the main page!</h1>
                </div>
              }
            />
            <Route
              path="/workers"
              element={
                <div
                  style={{
                    backgroundColor: 'lightgrey', // orange background
                    height: '100%',
                    width: '100%',
                    display: 'flex',
                    justifyContent: 'center',
                    alignItems: 'center',
                  }}
                >
                  <Workers />
                </div>
              }
            />
            <Route
              path="/Supervisors"
              element={
                <div
                  style={{
                    backgroundColor: 'lightgoldenrodyellow', // green background
                    height: '100%',
                    width: '100%',
                    display: 'flex',
                    justifyContent: 'center',
                    alignItems: 'center',
                  }}
                >
                  <Supervisors />
                </div>
              }
            />
            <Route
              path="/currentworkers"
              element={
                <div
                  style={{
                    backgroundColor: 'lightseagreen', // purple background
                    height: '100%',
                    width: '100%',
                    display: 'flex',
                    justifyContent: 'center',
                    alignItems: 'center',
                  }}
                >
                  <CurrentWorkers />
                </div>
              }
            />
          </Routes>
        </div>
      </div>
    </BrowserRouter>
  );
}

export default App;