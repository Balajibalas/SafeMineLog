import React from 'react';
import { BrowserRouter, Route, Routes, NavLink } from 'react-router-dom';
import Workers from './workers';
import Supervisors from './Supervisors';
import CurrentWorkers from './currentworkers';
import './App.css';

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
              <NavLink to="/" style={{ textDecoration: 'none', color: '#fff', fontSize: 25 }}>
                Home
              </NavLink>
            </li>
            <li style={{ marginRight: 20 }}>
              <NavLink to="/workers" style={{ textDecoration: 'none', color: '#fff', fontSize: 25 }}>
                Workers
              </NavLink>
            </li>
            <li style={{ marginRight: 20 }}>
              <NavLink to="/Supervisors" style={{ textDecoration: 'none', color: '#fff', fontSize: 25 }}>
                Supervisors
              </NavLink>
            </li>
            <li>
              <NavLink to="/currentworkers" style={{ textDecoration: 'none', color: '#fff', fontSize: 25 }}>
                Current Workers
              </NavLink>
            </li>
          </ul>
        </nav>

        <div
          style={{
            flex: 1,
            padding: 20,
            overflowX: 'hidden', 
          }}
        >
          <Routes>
            <Route
              path="/"
              element={
                <div
                  style={{
                    backgroundColor: '#DF7B2EFF',
                    height: '100%',
                    width: '100%',
                    display: 'flex',
                    justifyContent: 'center',
                    alignItems: 'center',
                    overflow: 'hidden',
                  }}
                >
                  <div
                    style={{
                      height: '74%',
                      width: '80%',
                      display: 'flex',
                      justifyContent: 'center',
                      alignItems: 'center',
                      backgroundColor: 'white',
                      borderRadius: '10px',
                    }}
                  >
                    <div
                      style={{
                        flex: 1,
                        display: 'flex',
                        justifyContent: 'center',
                        alignItems: 'center',
                        position: 'relative',
                      }}
                    >
                      <img
                        src="src/LOGO.png"
                        alt="Main Page Image"
                        style={{
                          maxHeight: '80%',
                          maxWidth: '80%',
                          margin: '20px',
                          borderRadius: '10px',
                        }}
                      />
                    </div>
                    <div
                      style={{
                        width: '2px',
                        backgroundColor: '#ddd',
                        height: '100%', 
                        alignSelf: 'stretch', 
                      }}
                    ></div>

                    <div
                      style={{
                        flex: 1,
                        display: 'flex',
                        justifyContent: 'center',
                        alignItems: 'center',
                        padding: '20px',
                      }}
                    >
                      <h1 style={{ fontSize: '2rem', textAlign: 'center' }}>Welcome to the main page!</h1>
                    </div>
                  </div>
                </div>
              }
            />
            <Route
              path="/workers"
              element={
                <div
                  style={{
                    backgroundColor: 'lightgrey',
                    height: '100%',
                    width: '100%',
                    display: 'flex',
                    justifyContent: 'center',
                    alignItems: 'center',
                    overflowY: 'auto',
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
                    backgroundColor: 'lightgoldenrodyellow',
                    height: '100%',
                    width: '100%',
                    display: 'flex',
                    justifyContent: 'center',
                    alignItems: 'center',
                    overflowY: 'auto',
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
                    backgroundColor: 'lightseagreen',
                    height: '100%',
                    width: '100%',
                    display: 'flex',
                    justifyContent: 'center',
                    alignItems: 'center',
                    overflowY: 'auto',
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
