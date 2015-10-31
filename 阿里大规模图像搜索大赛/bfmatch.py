import numpy as np
import cv2
from matplotlib import pyplot as plt

"""
Reference:
https://opencv-python-tutroals.readthedocs.org/en/latest/py_tutorials/py_feature2d/py_table_of_contents_feature2d/py_table_of_contents_feature2d.html

"""


def drawMatches(img1, kp1, img2, kp2, matches):
    """
    My own implementation of cv2.drawMatches as OpenCV 2.4.9
    does not have this function available but it's supported in
    OpenCV 3.0.0

    This function takes in two images with their associated 
    keypoints, as well as a list of DMatch data structure (matches) 
    that contains which keypoints matched in which images.

    An image will be produced where a montage is shown with
    the first image followed by the second image beside it.

    Keypoints are delineated with circles, while lines are connected
    between matching keypoints.

    img1,img2 - Grayscale images
    kp1,kp2 - Detected list of keypoints through any of the OpenCV keypoint 
              detection algorithms
    matches - A list of matches of corresponding keypoints through any
              OpenCV keypoint matching algorithm
			  
	http://stackoverflow.com/questions/20259025/module-object-has-no-attribute-drawmatches-opencv-python
    """

    # Create a new output image that concatenates the two images together
    # (a.k.a) a montage
    rows1 = img1.shape[0]
    cols1 = img1.shape[1]
    rows2 = img2.shape[0]
    cols2 = img2.shape[1]

    out = np.zeros((max([rows1,rows2]),cols1+cols2,3), dtype='uint8')

    # Place the first image to the left
    out[:rows1,:cols1] = np.dstack([img1, img1, img1])

    # Place the next image to the right of it
    out[:rows2,cols1:] = np.dstack([img2, img2, img2])

    # For each pair of points we have between both images
    # draw circles, then connect a line between them
    for mat in matches:

        # Get the matching keypoints for each of the images
        img1_idx = mat.queryIdx
        img2_idx = mat.trainIdx

        # x - columns
        # y - rows
        (x1,y1) = kp1[img1_idx].pt
        (x2,y2) = kp2[img2_idx].pt

        # Draw a small circle at both co-ordinates
        # radius 4
        # colour blue
        # thickness = 1
        cv2.circle(out, (int(x1),int(y1)), 4, (255, 0, 0), 1)   
        cv2.circle(out, (int(x2)+cols1,int(y2)), 4, (255, 0, 0), 1)

        # Draw a line in between the two points
        # thickness = 1
        # colour blue
        cv2.line(out, (int(x1),int(y1)), (int(x2)+cols1,int(y2)), (255, 0, 0), 1)


    # Show the image
    cv2.imshow('Matched Features', out)
    cv2.waitKey(0)
    cv2.destroyWindow('Matched Features')

    # Also return the image if you'd like a copy
    return out


"""
Brute-Force Matching with ORB Descriptors
"""

def bf_orb(src_img,des_img):
	img1 = cv2.imread(src_img,0)          # queryImage
	img2 = cv2.imread(des_img,0) # trainImage
	
	# Initiate SIFT detector
	orb = cv2.ORB()
	
	# find the keypoints and descriptors with SIFT
	kp1, des1 = orb.detectAndCompute(img1,None)
	kp2, des2 = orb.detectAndCompute(img2,None)
	
	# create BFMatcher object
	bf = cv2.BFMatcher(cv2.NORM_HAMMING, crossCheck=True)
	
	# Match descriptors.
	matches = bf.match(des1,des2)
	
	# Sort them in the order of their distance.
	matches = sorted(matches, key = lambda x:x.distance)
	
	# Draw first 10 matches.
	img3 = drawMatches(img1,kp1,img2,kp2,matches[:60])
	
	plt.imshow(img3),plt.show()



"""
Brute-Force Matching with SIFT Descriptors and Ratio Test
"""

def bf_sift():
	img1 = cv2.imread('1.png',0)          # queryImage
	img2 = cv2.imread('2.png',0) # trainImage
	
	# Initiate SIFT detector
	sift = cv2.SIFT()
	
	
	# find the keypoints and descriptors with SIFT
	kp1, des1 = sift.detectAndCompute(img1,None)
	kp2, des2 = sift.detectAndCompute(img2,None)
	
	# BFMatcher with default params
	bf = cv2.BFMatcher()
	matches = bf.knnMatch(des1,des2, k=2)
	
	# Apply ratio test
	good = []
	for m,n in matches:
	    if m.distance < 0.75*n.distance:
	        good.append([m])
	
	# cv2.drawMatchesKnn expects list of lists as matches.
	img3 = drawMatchesKnn(img1,kp1,img2,kp2,good)
	
	plt.imshow(img3),plt.show()
	

def flann():
	img1 = cv2.imread('1.jpg',0)          # queryImage
	img2 = cv2.imread('2.jpg',0) # trainImage
	
	# Initiate SIFT detector
	sift = cv2.SIFT()
	
	# find the keypoints and descriptors with SIFT
	kp1, des1 = sift.detectAndCompute(img1,None)
	kp2, des2 = sift.detectAndCompute(img2,None)
	
	# FLANN parameters
	FLANN_INDEX_KDTREE = 0
	index_params = dict(algorithm = FLANN_INDEX_KDTREE, trees = 5)
	search_params = dict(checks=50)   # or pass empty dictionary
	
	flann = cv2.FlannBasedMatcher(index_params,search_params)
	
	matches = flann.knnMatch(des1,des2,k=2)
	
	# Need to draw only good matches, so create a mask
	matchesMask = [[0,0] for i in xrange(len(matches))]
	
	# ratio test as per Lowe's paper
	for i,(m,n) in enumerate(matches):
	    if m.distance < 0.7*n.distance:
	        matchesMask[i]=[1,0]
	
	draw_params = dict(matchColor = (0,255,0),
	                   singlePointColor = (255,0,0),
	                   matchesMask = matchesMask,
	                   flags = 0)
	
	img3 = cv2.drawMatchesKnn(img1,kp1,img2,kp2,matches,None,**draw_params)
	
	plt.imshow(img3,),plt.show()
	
	
if __name__=="__main__":
	bf_orb('./0.jpg','./617000253230.jpg')
