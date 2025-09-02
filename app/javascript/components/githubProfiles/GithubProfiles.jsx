import React, { useState } from 'react';
import GithubProfileList from './GithubProfileList';
import GithubProfileForm from './GithubProfileForm';
import GithubProfileShow from './GithubProfileShow';

const GithubProfiles = () => {
  const [editing, setEditing] = useState(null);
  const [showing, setShowing] = useState(null);
  const [refresh, setRefresh] = useState(false);

  const handleEdit = (profile) => setEditing(profile);
  const handleShow = (profile) => setShowing(profile);
  const handleSuccess = () => {
    setEditing(null);
    setRefresh(!refresh);
  };

  if (showing) {
    return (
      <GithubProfileShow
        profileId={showing.id}
        onBack={() => setShowing(null)}
      />
    );
  }

  return (
    <div className="container mt-5">
      <h1 className="text-primary">Perfis Github</h1>
      <GithubProfileForm
        profile={editing}
        onSuccess={handleSuccess}
        onCancel={() => setEditing(null)}
      />
      <GithubProfileList key={refresh} onEdit={handleEdit} onShow={handleShow} />
    </div>
  );
};

export default GithubProfiles;