# Repairing 3D models obtained from range sensors
The main file of the application, to start the process, is 'regenera_inpainting3.m'.
The rest of files are called during the execution.

Release: 
[Regenera inpainting v1.0](https://github.com/3dcovim/Repairing-3D-models-obtained-from-range-sensors/releases)

# Features
The current version of this set of Matlab files provides the following features:
* Automated Hole Identification: The algorithm automatically identifies "badly sensed" areas or holes in 3D polygonal meshes by detecting boundary edges that are not shared by two triangles (non-manifold edges).
* Intelligent Mesh Portion Extraction: Instead of processing the entire model, the code extracts a specific "zone of interest" around each hole. It calculates the optimal size of this area based on the mesh resolution and the average length of the edges.
* Curvature-Adaptive Selection (Normal Diffusion): To avoid projection errors in complex areas, the method includes a normal diffusion algorithm. It monitors changes in surface curvature and limits the growth of the processed area if the normals change too abruptly.
* 3D-to-2D Optimized Projection: The system projects 3D mesh data onto an automatically computed reference plane that maximizes the projected area of the hole. This converts 3D coordinates into a 2D range image where pixel values represent height.
* Handling of Complex/Self-Intersecting Holes: The code can detect if a hole's boundary self-intersects when projected. In such cases, it automatically subdivides the complex hole into simple sub-polygons to process them independently.
* Inverse Transformation & Triangulation: After the 2D image is repaired, the code performs an inverse 2D-to-3D transformation. It then applies a Delaunay-based triangulation (specifically 2.5D) to create a new mesh patch that is seamlessly integrated into the original model.
* Robustness to Non-Sensed Zones: The framework is specifically designed to recover data lost due to occlusions or inaccessible crevices during the scanning process with range sensors.

# Citation
Reference this work:

[https://doi.org/10.1109/ACCESS.2021.3061525](https://doi.org/10.1109/ACCESS.2021.3061525)

E. Pérez, S. Salamanca, P. Merchán and A. Adán, "Repairing 3D Models Obtained From Range Sensors," in IEEE Access, vol. 9, pp. 43474-43493, 2021, doi: 10.1109/ACCESS.2021.3061525.


**BibTeX**

@ARTICLE{9360829,
  author={Pérez, Emiliano and Salamanca, Santiago and Merchán, Pilar and Adán, Antonio},
  journal={IEEE Access}, 
  title={Repairing 3D Models Obtained From Range Sensors}, 
  year={2021},
  volume={9},
  number={},
  pages={43474-43493},
  keywords={Three-dimensional displays;Sensors;Solid modeling;Two dimensional displays;Image restoration;Surface reconstruction;Shape;Range sensors;polygonal models;mesh repair},
  doi={10.1109/ACCESS.2021.3061525}}


# Authors
This development belongs to the Computer Vision & 3D Modelling Laboratory (3DCo-Vim) research group.

<picture>
  <img alt="3DCo-Vim Logo." src="https://3dcovim.cms.unex.es/wp-content/uploads/sites/2/2023/03/cropped-cropped-Imagen23-1-2.png">
</picture>

Website: [https://3dcovim.cms.unex.es/](https://3dcovim.cms.unex.es/)
# Origins
This work is based on the thesis "Filling techniques in surfaces acquired using 3D scanners" (
["Técnicas de relleno de superficies adquiridas mediante escáneres 3D"](https://hdl.handle.net/20.500.14468/21263)
supervised by [Carlos Cerrada Somolinos](https://orcid.org/0000-0002-8591-6581) and [Santiago Salamanca Miño](https://orcid.org/0000-0001-5878-5988) 
and presented in 2011 at the National University of Distance Education.

# License
These files are licensed under the Creative Commons Attribution license (CC BY 4.0)

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://licensebuttons.net/l/by-nc/3.0/88x31.png">
  <img alt="License" src="https://licensebuttons.net/l/by-nc/3.0/88x31.png">
</picture>

https://creativecommons.org/licenses/by-nc/4.0/
