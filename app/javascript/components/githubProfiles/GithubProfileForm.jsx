import React, { useState, useEffect } from 'react';

const GithubProfileForm = ({ profile, onSuccess, onCancel }) => {
  const [name, setName] = useState(profile ? profile.name : '');
  const [githubUrl, setGithubUrl] = useState(profile ? profile.github_url : '');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

  useEffect(() => {
    setName(profile ? profile.name : '');
    setGithubUrl(profile ? profile.github_url : '');
    setError('');
  }, [profile]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    const method = profile ? 'PATCH' : 'POST';
    const url = profile ? `/github_profiles/${profile.id}` : '/github_profiles';
    const response = await fetch(url, {
      method,
      headers: { 'Content-Type': 'application/json', 'X-CSRF-Token': csrfToken },
      body: JSON.stringify({ github_profile: { name, github_url: githubUrl } }),
    });
    setLoading(false);
    if (response.ok) {
      onSuccess();
      setName('');
      setGithubUrl('');
    } else {
      const data = await response.json();
      setError(data.name ? data.name.join(', ') : 'Erro ao salvar perfil');
    }
  };

  return (
    <div className="d-flex justify-content-center align-items-center min-vh-50">
      <div className="card shadow-sm" style={{ maxWidth: 600, width: '100%' }}>
        <div className="card-body">
          <div className="text-center mb-3">
            <i className="bi bi-person-plus" style={{ fontSize: '2rem', color: '#0d6efd' }}></i>
            <h4 className="mt-2">{profile ? 'Editar Perfil Github' : 'Novo Perfil Github'}</h4>
            <p className="text-muted mb-0">{profile ? 'Altere os dados do perfil' : 'Cadastre um novo perfil do Github para indexar.'}</p>
          </div>
          {error && (
            <div className="alert alert-danger py-2" role="alert">
              {error}
            </div>
          )}
          <form onSubmit={handleSubmit} autoComplete="off">
            <div className="mb-3">
              <label htmlFor="profileName" className="form-label">Nome</label>
              <input
                id="profileName"
                type="text"
                className="form-control"
                placeholder="Ex: Matz"
                value={name}
                onChange={e => setName(e.target.value)}
                required
                disabled={loading}
                maxLength={50}
              />
            </div>
            <div className="mb-3">
              <label htmlFor="githubUrl" className="form-label">Endereço Github</label>
              <input
                id="githubUrl"
                type="url"
                className="form-control"
                placeholder="https://github.com/usuario"
                value={githubUrl}
                onChange={e => setGithubUrl(e.target.value)}
                required
                disabled={loading}
                maxLength={100}
              />
            </div>
            <div className="d-grid gap-2">
              <button type="submit" className="btn btn-primary" disabled={loading}>
                {loading ? (
                  <span className="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
                ) : null}
                {profile ? 'Salvar Alterações' : 'Cadastrar'}
              </button>
              {profile && (
                <button type="button" className="btn btn-outline-secondary" onClick={onCancel} disabled={loading}>
                  Cancelar
                </button>
              )}
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default GithubProfileForm;