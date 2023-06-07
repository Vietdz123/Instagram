<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="imgaes/logo.png" alt="Logo" width="80" height="80" style="border-radius: 20px;">
  </a>

  <h3 align="center">Instagram</h3>

  <p align="center">
    An awesome README template to jumpstart your projects!
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template">View Demo</a>
    ·
    <a href="https://github.com/othneildrew/Best-README-Template/issues">Report Bug</a>
    ·
    <a href="https://github.com/othneildrew/Best-README-Template/issues">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About The Project

<div align="center">
<img src="images/product_screenShort1.jpg" alt="Logo" width="320" height="370" style="border-radius: 10px;">
</div>

This is a my personal project where  I am trying to emulate the features of Instagram after using them. I have utilized several frameworks and classes, including:
- **UICollectionViewCompositionalLayout**: : To create multiple sections with various layouts and sizes.
- **PhotosKit**: For loading images from the user's photo library.
- **AVFoundation**: For capturing photos.
- **DispathQueue and DispathGroup**: Fetching Data with multiple Threads.
- **UIview.animate(), CGAffineTransform(), UIPanGestureRecognizer()**: Enhancing user experiences.
- **Firebase**: For user authentication and user data storage.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started
Instagram have 4 main Controlers:
- ***ProfileConttroller***:  This controller is responsible for editing the user's profile, as well as managing the follow and unfollow actions for other users. Depending on the user's identity and the screen they are presented from, different layouts will be displayed.
- ***HomeController***: This controller is used to display the photo statuses. Users can perform actions such as liking, commenting, and viewing users who have liked a particular status.
- ***PickPhotoController***: From this controller, users can select images from their own photo library or capture new photos to post as statuses.
- ***ExploreController***: This controller is used to showcase other users' statuses and enables searching for other users.

Implementing **HomeController** has been both interesting and challenging. It took me 6 days to complete. To support both vertical and horizontal scrolling, I had to implement two scroll views and two child controllers
-  **HeaderProfileController**: This controller displays user information and handles follow/unfollow actions.
-  **Bottom ProfileController**: BottomProfileController is a controller that contains three child controllers for horizontal scrolling.
-  ContainerScrollView: This scroll view is responsible for containing the views of the two child controllers mentioned above.
-  OverlayScrollView: This scroll view is responsible for containing the views of the two child controllers mentioned above. 
  
In addition, I have also customized a Bottom Sheet Controller for the logout and settings functionality

# I. ProfileController

Main Feature ProfileController
- Scroll is like Instagram

<div align="center">
<img src="gif/scrollLikeInsta.gif" alt="Logo" width="200" height="440" style="border-radius: 10px;">
</div>


- Custom BottomSheetController and Logout

<div align="center">
<img src="gif/bottomSheetAndLogout.gif" alt="Logo" width="200" height="440" style="border-radius: 10px;">
</div>

- Edit Profile

<div align="center">
<img src="gif/editProfile.gif" alt="Logo" width="200" height="440" style="border-radius: 10px;">
</div>

- Check who i am following and who is following me

<div align="center">
<img src="gif/follow.gif" alt="Logo" width="200" height="440" style="border-radius: 10px;">
</div>

# II. HomeController
- Dynamic Size Cell 

![](gif/dynamicSize.gif)

- Likes and Comments Status

![](gif/LikeAndComment.gif)

- Profile của users khác

![](gif/anotherProfile.gif)



