I aimed to create an experience that encourages users to explore their creativity through a gamified approach.  
<img src="https://github.com/user-attachments/assets/32b419c3-38aa-4cc9-b353-f26fb02b361d" alt="20250519-135245-min" width="400"/>


The app consists of two main sections: Finding and Collection. In Finding, users can view the letters they’ve yet to collect. My goal was to make the experience efficient, delightful, and motivational. To help users remember which letters are still uncollected, I designed a sliding card interface with subtle hints about the letter shapes, using SwiftUI’s scrolling features. The interface is smooth, intuitive, and visually engaging, leveraging state-driven animations to celebrate progress and motivate continued exploration.

For capturing images, I integrated AVFoundation to provide a live camera preview, allowing users to compose shots carefully. AVFoundation also supports high-quality image saving and zoom functionality, which is crucial for capturing precise letter shapes. This simple yet powerful feature was critical for the app's core functionality.

The second part of the app, Collection, is focused on managing progress. I wanted users to track the letters they’ve collected and revisit the experience over time. I created a collection structure to help users organize their alphabet hunts into different themes, keeping the experience fresh. I chose SwiftData for persistent storage because it’s more intuitive than CoreData. SwiftData made managing data easier, and it allowed for sorting and filtering, so users can view their collections in various ways.

I also integrated PhotoUI to make it easy for users to upload specific images using an image picker. AVFoundation played a role in providing the live camera preview and saving images, while PhotoUI helped capture and save the final letter grid when users complete their collections.

AI was instrumental in supporting my development process. It helped me prioritize the app's minimum viable product (MVP), ensuring I focused on essential features. By helping me manage the project scope, AI allowed me to avoid unnecessary complexity and stay on track. It also played a crucial role in debugging. At times, I struggled to understand the meaning behind certain errors, and AI provided valuable insights that helped me troubleshoot and resolve issues quickly. It also assisted with spotting simple mistakes and provided quick solutions. When it came to motivational quotes, AI helped me brainstorm ideas, making it easier to find the right ones to inspire users despite the difficulty in collecting them.

