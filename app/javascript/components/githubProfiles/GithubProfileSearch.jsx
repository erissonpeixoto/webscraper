import React from 'react';

const GithubProfileSearch = ({ value, onChange }) => (
  <div className="mb-4">
    <label htmlFor="github-profile-search" className="form-label fw-semibold">
      Buscar perfis
    </label>
    <div className="input-group">
      <span className="input-group-text">
        <i className="bi bi-search"></i>
      </span>
      <input
        id="github-profile-search"
        type="text"
        className="form-control"
        placeholder="Digite o nome, usuário do Github, organização ou localização"
        value={value}
        onChange={e => onChange(e.target.value)}
        autoComplete="off"
      />
    </div>
  </div>
);

export default GithubProfileSearch;