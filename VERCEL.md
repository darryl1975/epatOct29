## How to get VERCEL_TOKEN

This is your personal access token that grants GitHub permission to deploy to your account.
1. Go to your Vercel Dashboard.
2. Click on your profile picture in the top-right corner and select Settings.
3. In the left-hand sidebar, click on Tokens.
4. Click Create (or Create Token).
5. Give it a descriptive name (e.g., GitHub Actions CI/CD).
6. Set the scope to Full Access (or limit it to your specific Team).
7. Click Create Token and copy the generated string immediately. (You will not be able to see it again).


## How to get VERCEL_ORG_ID & VERCEL_PROJECT_ID

The easiest way to find these IDs is by running a quick command in your project's terminal on your computer.

### Step A: Link your project locally

If you haven't linked your local repository to a Vercel project yet, run this in your root folder:

npx vercel link


### Step B: Read the IDs

Once linked, Vercel creates a hidden folder named .vercel/ in your root directory. Open the project.json file inside it:

cat .vercel/project.json

You will see a JSON object containing both IDs:

{
  "orgId": "team_xxxxxxxxxxxxxxxxxxxx",      // <--- This is your VERCEL_ORG_ID
  "projectId": "prj_xxxxxxxxxxxxxxxxxxxx"  // <--- This is your VERCEL_PROJECT_ID
}


## Save them to GitHub

Now that you have all three values, add them safely to your repository:
1. Open your repository on GitHub.
2. Go to Settings > Secrets and variables > Actions.
3. Under the Secrets tab, click New repository secret.
4. Add them one by one matching these exact names:
	• VERCEL_TOKEN
	• VERCEL_ORG_ID
	• VERCEL_PROJECT_ID

Once those are saved, your next git push to your deployment branch will kick off the build seamlessly.