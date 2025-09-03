import React, { useState } from 'react';
import GithubProfileList from './GithubProfileList';
import GithubProfileForm from './GithubProfileForm';
import GithubProfileShow from './GithubProfileShow';
import GithubProfileSearch from './GithubProfileSearch';

const GithubProfiles = () => {
  const [editing, setEditing] = useState(null);
  const [showing, setShowing] = useState(null);
  const [refresh, setRefresh] = useState(false);
  const [search, setSearch] = useState('');

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
      <h3 className="text-primary mb-4">Perfis Github</h3>
      <div className="mb-4">
        <GithubProfileForm
          profile={editing}
          onSuccess={handleSuccess}
          onCancel={() => setEditing(null)}
        />
      </div>
      <div className="mb-4">
        <GithubProfileSearch value={search} onChange={setSearch} />
      </div>
      <GithubProfileList
        key={refresh}
        onEdit={handleEdit}
        onShow={handleShow}
        search={search}
      />
    </div>
  );
};

export default GithubProfiles;