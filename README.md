
https://user-images.githubusercontent.com/11559134/120465233-6b78d300-c3a6-11eb-8514-08d9da97d9a0.mov

# PinOnTheMap
**Project Overview** <br />
PinOnTheMap is an an app with a map that shows information posted by other students. The map contains pins that show the location where other students have reported studying. By tapping on the pin users can see a URL for something the student finds interesting. The user are able to add their own data by posting a string that can be reverse geocoded to a location, and a URL.

**The app has three pages of content:** <br />

<ul>
  <li> <b>Login View:</b> Allows the user to log in using their Udacity credentials </li>
  <li> <b>Map and Table Tabbed View:</b> Allows users to see the locations of other students in two formats.</li>
  <li> <b>Information Posting View:</b> Allows the users specify their own locations and links. </li>
</ul>

**Features** <br />
<ul>
  <li>Shared Model </li>
  <li>The networking and JSON parsing code is located in a dedicated API client class </li>
  <li>The networking code uses Swift's built-in URLSession library, not a third-party framework.</li>
  <li>The JSON parsing code uses Swift's built-in JSONSerialization library or Codable, not a third-party framework.</li>
  <li>The app successfully encodes the data in JSON and posts the search string and coordinates to the RESTful service.</li>
  <li>The app gracefully handles a failure to download student locations.</li>
  <li>The app displays downloaded data in a tabbed view with two tabs: a map and a table.</li>
  <li>Map view contain a pin for each of the locations that were downloaded</li>
</ul>

**The application offers** <br />
<ul>
  <li> The login view accepts the email address and password that students use to login to the Udacity site.</li>
  <li> When the user taps the Login button, the app will attempt to authenticate with Udacity’s servers.</li>
  <li>Clicking on the Sign Up link will open Safari to the Udacity sign-up page.</li>
  <li>If the login does not succeed, the user will be presented with an alert view specifying whether it was a failed network connection, or an incorrect email and password</li>
  <!--  <li>Delete saved Memes in your list.</li> -->
  <li>When the map tab is selected, the view displays a map with pins specifying the last 100 locations posted by students.</li>
  <li>The app shows a placemark on a map via the geocoded response. The app zooms the map into an appropriate region.</li>
  <li>When the user taps a pin, it displays the pin annotation popup, with the student’s name (pulled from their Udacity profile) and the link associated with the student’s pin</li>
  <li>Tapping anywhere within the annotation will launch Safari and direct it to the link associated with the pin.</li>
  <li>When the table tab is selected, the most recent 100 locations posted by students are displayed in a table</li>
  <li>Each row displays the name from the student’s Udacity profile. Tapping on the row launches Safari and opens the link associated with the student.</li>
  <li>Both the map tab and the table tab share the same top navigation bar.</li>
  <li>The rightmost bar button will be a refresh button. Clicking on the button will refresh the entire data set by downloading and displaying the most recent 100 posts made by students.</li>
  <li>The bar button directly to its right will be a plus button. Clicking on the plus button will modally present the Information Posting View.</li>
  <li>When the Information Posting View is modally presented, the user sees two text fields: one asks for a location and the other asks for a link.</li>
  <li>When the user clicks on the “Find Location” button, the app will forward geocode the string. If the forward geocode fails, the app will display an alert view notifying the user. Likewise, an alert will be displayed if the link is empty.</li>
  <li>If the forward geocode succeeds then text fields will be hidden, and a map showing the entered location will be displayed. Tapping the “Add Location” button will post the location and link to the server.</li>
  <li>If the submission fails to post the data to the server, then the user should see an alert with an error message describing the failure.</li>
  <li>If at any point the user clicks on the “Cancel” button, then the Information Posting View should be dismissed, returning the app to the Map and Table Tabbed View.</li>
  <li>Likewise, if the submission succeeds, then the Information Posting View should be dismissed, returning the app to the Map and Table Tabbed View.</li>
  <li>Optional (but fun) task: The “Sign in with Facebook” button in the image authenticates with Facebook. Authentication with Facebook may occur through the device’s accounts or through Facebook’s website.</li>
</ul>
