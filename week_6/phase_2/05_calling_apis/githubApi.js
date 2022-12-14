const got = require('got');

class GithubApi {
  constructor() {}

  fetchRepositoryData(repo, repositoryData) {
    const url = 'https://api.github.com/repos/' + repo;
    got(url).then((response) => {
      repositoryData(JSON.parse(response.body));
    });
  };
}

module.exports = GithubApi;
