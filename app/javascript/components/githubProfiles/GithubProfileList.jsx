import React, { useEffect, useState } from 'react';

const GithubProfileList = ({ onEdit, onShow, search }) => {
  const [profiles, setProfiles] = useState([]);

  const fetchProfiles = async () => {
    const query = search ? `?name=${encodeURIComponent(search)}` : '';
    const res = await fetch(`/github_profiles${query}`);
    const data = await res.json();
    setProfiles(data);
  };

  useEffect(() => {
    fetchProfiles();
    // eslint-disable-next-line
  }, [search]);

  const handleDelete = async (id) => {
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
    await fetch(`/github_profiles/${id}`, { method: 'DELETE', headers: { 'X-CSRF-Token': csrfToken } });
    fetchProfiles();
  };

  return (
    <div className="container py-4">
      <div className="d-flex align-items-center mb-4">
        <i className="bi bi-person-lines-fill text-primary" style={{ fontSize: '2rem' }}></i>
        <h4 className="ms-2 mb-0">Listagem</h4>
      </div>
      {profiles.length === 0 ? (
        <div className="alert alert-info text-center">
          Nenhum perfil cadastrado ainda.
        </div>
      ) : (
        <div className="table-responsive">
          <table className="table table-hover align-middle shadow-sm">
            <thead className="table-light">
              <tr>
                <th scope="col">Nome</th>
                <th scope="col">Endereço Github (encurtado)</th>
                <th scope="col" className="text-end">Ações</th>
              </tr>
            </thead>
            <tbody>
              {profiles.map(profile => (
                <tr key={profile.id}>
                  <td className="fw-semibold">{profile.name}</td>
                  <td>
                    <a href={profile.short_github_url} target="_blank" rel="noopener noreferrer">
                      {profile.short_github_url}
                    </a>
                  </td>
                  <td className="text-end">
                    <button
                      className="btn btn-sm btn-outline-info me-2"
                      title="Visualizar"
                      onClick={() => onShow(profile)}
                    >
                      <i className="bi bi-eye"></i>
                    </button>
                    <button
                      className="btn btn-sm btn-outline-primary me-2"
                      title="Editar"
                      onClick={() => onEdit(profile)}
                    >
                      <i className="bi bi-pencil"></i>
                    </button>
                    <button
                      className="btn btn-sm btn-outline-danger"
                      title="Excluir"
                      onClick={() => handleDelete(profile.id)}
                    >
                      <i className="bi bi-trash"></i>
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
};

export default GithubProfileList;