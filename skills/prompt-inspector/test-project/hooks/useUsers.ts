import axios from 'axios';
import { useState, useEffect } from 'react';

export function useUsers() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    axios.get('/api/users').then((res) => {
      setUsers(res.data);
      setLoading(false);
    });
  }, []);

  const createUser = async (userData: { name: string; email: string }) => {
    const res = await axios.post('/api/users', userData);
    return res.data;
  };

  const deleteUser = async (id: number) => {
    await axios.delete(`/api/users?id=${id}`);
  };

  return { users, loading, createUser, deleteUser };
}
