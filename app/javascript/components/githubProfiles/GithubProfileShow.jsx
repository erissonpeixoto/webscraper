import React, { useEffect, useState } from 'react';

const GithubProfileShow = ({ profileId, onBack }) => {
  const [profile, setProfile] = useState(null);

  useEffect(() => {
    const fetchProfile = async () => {
      const res = await fetch(`/github_profiles/${profileId}`);
      if (res.ok) {
        const data = await res.json();
        setProfile(data);
      }
    };
    fetchProfile();
  }, [profileId]);

  if (!profile) {
    return (
      <div className="text-center py-5">
        <div className="spinner-border text-primary" role="status" />
      </div>
    );
  }

  return (
    <div className="container py-4">
      <button className="btn btn-link mb-3" onClick={onBack}>
        <i className="bi bi-arrow-left"></i> Voltar
      </button>
      <div className="card shadow-sm mx-auto" style={{ maxWidth: 500 }}>
        <div className="card-body text-center">
          <img
            src={profile.avatar_url}
            alt={profile.name}
            className="rounded-circle mb-3"
            style={{ width: 120, height: 120, objectFit: 'cover', border: '3px solid #eee' }}
          />
          <h3 className="mb-1">{profile.name}</h3>
          <a href={profile.github_url} target="_blank" rel="noopener noreferrer" className="d-block mb-2">
            {profile.github_url_short}
          </a>
          <div className="row mb-3">
            <div className="col-6 text-end fw-bold">Usuário Github:</div>
            <div className="col-6 text-start">{profile.github_username}</div>
            <div className="col-6 text-end fw-bold">Followers:</div>
            <div className="col-6 text-start">{profile.followers}</div>
            <div className="col-6 text-end fw-bold">Following:</div>
            <div className="col-6 text-start">{profile.following}</div>
            <div className="col-6 text-end fw-bold">Stars:</div>
            <div className="col-6 text-start">{profile.stars}</div>
            <div className="col-6 text-end fw-bold">Contribuições (últ. ano):</div>
            <div className="col-6 text-start">{profile.contributions}</div>
            <div className="col-6 text-end fw-bold">Organização:</div>
            <div className="col-6 text-start">{profile.organization || '-'}</div>
            <div className="col-6 text-end fw-bold">Localização:</div>
            <div className="col-6 text-start">{profile.location || '-'}</div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default GithubProfileShow;