<script lang="ts">
  import { onMount } from "svelte";

  let sshName = "ssh-host";
  let path = "/path/to/project";
  $: address = `vscode://vscode-remote/ssh-remote+${sshName}/${path}?windowId=_blank`;
  let sshHistory: string[] = [];
  let pathHistory: string[] = [];

  enum Field {
    sshName = "sshName",
    path = "path",
  }

  onMount(() => {
    sshHistory = JSON.parse(localStorage.getItem("sshHistory") || "[]");
    if (sshHistory.length > 0) {
      sshName = sshHistory[0];
    }

    pathHistory = JSON.parse(localStorage.getItem("pathHistory") || "[]");
    if (pathHistory.length > 0) {
      path = pathHistory[0];
    }
  });

  const updateHistory = (field: Field, value: string) => {
    if (field === Field.sshName && !sshHistory.includes(value)) {
      sshHistory.push(value);
      localStorage.setItem("sshHistory", JSON.stringify(sshHistory));
    } else if (field === Field.path && !pathHistory.includes(value)) {
      pathHistory.push(value);
      localStorage.setItem("pathHistory", JSON.stringify(pathHistory));
    }
  };

  const open = () => {
    // ensure the ssh name and path are not empty
    if (!sshName || !path) {
      alert("SSH Name and Path are required");
      return;
    }

    // update the history
    updateHistory(Field.sshName, sshName);
    updateHistory(Field.path, path);

    window.open(
      `vscode://vscode-remote/ssh-remote+${sshName}/${path}?windowId=_blank`
    );
  };

  const clearHistory = () => {
    localStorage.removeItem("sshHistory");
    localStorage.removeItem("pathHistory");
    sshHistory = [];
    pathHistory = [];
  };

  const copyAddress = () => {
    navigator.clipboard.writeText(address);
    alert(`Copied ${address} to clipboard`);
  };
</script>

<main>
  <h1>Open VSCode Remote</h1>

  <!-- History -->
  <div style="display: flex; align-items: center">
    <button on:click={clearHistory}>Clear History</button>
    <p>
      History size:
      <span>{sshHistory.length} + {pathHistory.length}</span>
    </p>
  </div>

  <!-- Field to enter ssh host name -->
  <div>
    <label for="ssh-name">SSH Name</label>
    <input
      type="text"
      id="ssh-name"
      bind:value={sshName}
      autocomplete="on"
      list="ssh-history"
    />
    <datalist id="ssh-history">
      {#each sshHistory as item (item)}
        <option value={item}> </option>
      {/each}
    </datalist>
  </div>

  <!-- Field to enter path -->
  <div>
    <label for="path">Path</label>
    <input
      type="text"
      id="path"
      bind:value={path}
      autocomplete="on"
      list="path-history"
    />
    <datalist id="path-history">
      {#each pathHistory as item (item)}
        <option value={item}> </option>
      {/each}
    </datalist>
  </div>

  <!-- Interactive Address -->
  <div style="display: flex">
    <button on:click={open}>Open</button>
    <button on:click={copyAddress}>Copy</button>
  </div>
</main>

<style>
  main {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 20px;
    font-family: Arial, sans-serif;
  }

  label {
    display: block;
    margin-top: 20px;
    font-weight: bold;
  }

  input {
    margin-top: 5px;
    padding: 10px;
    width: 600px;
    border: 1px solid #ccc;
    border-radius: 4px;
  }

  button {
    margin: 20px;
    padding: 10px 20px;
    background-color: #4caf50;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    text-decoration: none;
    display: block;
  }

  button:hover {
    background-color: #45a049;
  }
</style>
