<!-- PROJECT LOGO -->
<br />
<div align="center">
  <table>
  <tr><td>
  <a href="https://enclaive.io/products/">
    <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/php/php-original.svg" alt="PHP-SGX" width="120" >
  </a>
  </td></tr>
  </table>

  <h2 align="center">PHP-SGX: Run PHP applications in the safest Confidential Compute Environment</h2>

  <p align="center">
    <h3>packed by <a href="https://enclaive.io">enclaive</a></h3>
    </br>
    #intelsgx #confidentialcompute #zerotrust #cloud
    <br />
    <a href="#contributing">Contribute</a>
    ·
    <a href="https://github.com/enclaive/enclaive-docker-php-sgx/issues">Report Bug</a>
    ·
    <a href="https://github.com/enclaive/enclaive-docker-php-sgx/issues">Request Feature</a>
  </p>
        <a href="https://www.youtube.com/watch?v=DbxZuflYtC8">
          <img align="center" src="https://img.youtube.com/vi/DbxZuflYtC8/0.jpg"></img>
        </a>
        <br>Demo-Video: Wordpress in PHP-SGX Confidenital Container 
        (<a href="https://github.com/enclaive/enclaive-docker-php-sgx/tree/demo">read more</a>)                                                           
</div>

## TL;DR

```sh
cp .env.example .env
# edit .env
docker pull enclaive/php-sgx
# or
docker compose up
```
**Warning:** This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the build section for a more secure deployment.

<!-- INTRODCUTION -->
## What is PHP?

PHP is a general-purpose scripting language geared toward web development. It was originally created by Danish-Canadian programmer Rasmus Lerdorf in 1994. The PHP reference implementation is now produced by The PHP Group

[Overview of PHP](https://php.net/)

> Intel Security Guard Extension (SGX) delivers advanced hardware and RAM security encryption features, so called enclaves, in order to isolate code and data that are specific to each application. When data and application code run in an enclave additional security, privacy and trust guarantees are given, making the container an ideal choice for (untrusted) cloud environments.

[Overview of Intel SGX](https://www.intel.com/content/www/us/en/developer/tools/software-guard-extensions/overview.html)

Application code executing within an Intel SGX enclave:

- Remains protected even when the BIOS, VMM, OS, and drivers are compromised, implying that an attacker with full execution control over the platform can be kept at bay
- Benefits from memory protections that thwart memory bus snooping, memory tampering and “cold boot” attacks on images retained in RAM
- At no moment in time data, program code and protocol messages are leaked or de-anonymized
- Reduces the trusted computing base of its parent application to the smallest possible footprint

<!-- WHY -->
## Why use PHP-SGX (instead of "vanilla" PHP) images?
Following benefits come for free with PHP-SGX :

* Protect PHP code, files, applications, services, plugins against intelectual property theft/violation irrespectively where the application runs thanks to full fledge memory container encryption and integrity protection at runtime
* Shield container application against container escape attacks with hardware-graded security against kernel-space exploits, malicious and accidental privilege [insider](https://www.ibm.com/topics/insider-threats) attacks, [UEFI firmware](https://thehackernews.com/2022/02/dozens-of-security-flaws-discovered-in.html) exploits and other "root" attacks using the corruption of the application to infiltrate your network and system
* Build and deploy PHP application as usual while inheriting literally for free security and privacy through containerization including
    * strictly better TOMs (technical and organizatorial measures)
    * privacy export regulations compliant deployment anywhere, such as [Schrems-II](https://www.europarl.europa.eu/RegData/etudes/ATAG/2020/652073/EPRS_ATA(2020)652073_EN.pdf)
    * GDPR/CCPA compliant processing ("data in use") of user data (in the cloud) as data is relatively anonymized thanks to the enclave


<!-- DEPLOY IN THE CLOUD -->
## How to deploy PHP-SGX in a zero-trust cloud?

The following cloud infrastractures are SGX-ready out of the box
* [Microsoft Azure Confidential Cloud](https://azure.microsoft.com/en-us/solutions/confidential-compute/) 
* [OVH Cloud](https://docs.ovh.com/ie/en/dedicated/enable-and-use-intel-sgx/)
* [Alibaba Cloud](https://www.alibabacloud.com/blog/alibaba-cloud-released-industrys-first-trusted-and-virtualized-instance-with-support-for-sgx-2-0-and-tpm_596821)
* [Kraud Cloud](https://kraud.cloud)

Confidential compute is a fast growing space. Cloud providers continiously add confidential compute capabilities to their portfolio. Please [contact](#contact) us if the infrastracture provider of your preferred choice is missing.

<!-- GETTING STARTED -->
## Getting started
### Platform requirements

Check for *Intel Security Guard Extension (SGX)* presence by running the following
```
grep sgx /proc/cpuinfo
```
Alternatively have a thorough look at Intel's [processor list](https://www.intel.com/content/www/us/en/support/articles/000028173/processors.html). (We remark that macbooks with CPUs transitioned to Intel are unlikely supported. If you find a configuration, please [contact](#contact) us.)

Note that in addition to SGX the hardware module must support FSGSBASE. FSGSBASE is an architecture extension that allows applications to directly write to the FS and GS segment registers. This allows fast switching to different threads in user applications, as well as providing an additional address register for application use. If your kernel version is 5.9 or higher, then the FSGSBASE feature is already supported and you can skip this step.

There are several options to proceed
* If: No SGX-ready hardware </br> 
[Azure Confidential Compute](https://azure.microsoft.com/en-us/solutions/confidential-compute/") cloud offers VMs with SGX support. Prices are fair and have been recently reduced to support the [developer community](https://azure.microsoft.com/en-us/updates/announcing-price-reductions-for-azure-confidential-computing/). First-time users get $200 USD [free](https://azure.microsoft.com/en-us/free/) credit. Other cloud provider like [OVH](https://docs.ovh.com/ie/en/dedicated/enable-and-use-intel-sgx/) or [Alibaba](https://www.alibabacloud.com/blog/alibaba-cloud-released-industrys-first-trusted-and-virtualized-instance-with-support-for-sgx-2-0-and-tpm_596821) cloud have similar offerings.
* Elif: Virtualization <br>
  Ubuntu 21.04 (Kernel 5.11) provides the driver off-the-shelf. Read the [release](https://ubuntu.com/blog/whats-new-in-security-for-ubuntu-21-04). Go to [download](https://ubuntu.com/download/desktop) page.
* Elif: Kernel 5.9 or higher <br>
Install the DCAP drivers from the Intel SGX [repo](https://github.com/intel/linux-sgx-driver)

  ```sh
  sudo apt update
  sudo apt -y install dkms
  wget https://download.01.org/intel-sgx/sgx-linux/2.13.3/linux/distro/ubuntu20.04-server/sgx_linux_x64_driver_1.41.bin -O sgx_linux_x64_driver.bin
  chmod +x sgx_linux_x64_driver.bin
  sudo ./sgx_linux_x64_driver.bin

  sudo apt -y install clang-10 libssl-dev gdb libsgx-enclave-common libsgx-quote-ex libprotobuf17 libsgx-dcap-ql libsgx-dcap-ql-dev az-dcap-client open-enclave
  ```

* Else: Kernel older than version 5.9 </br>
  Upgrade to Kernel 5.11 or higher. Follow the instructions [here](https://ubuntuhandbook.org/index.php/2021/02/linux-kernel-5-11released-install-ubuntu-linux-mint/).   

<!-- GET THIS IMAGE -->
### Get this image

The recommended way to get the enclaive PHP-SGX Open Source Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/enclaive/php-sgx).

```console
docker pull enclaive/php-sgx:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/enclaive/php-sgx/tags/)
in the Docker Hub Registry.

```console
docker pull enclaive/php-sgx:[TAG]
```

<!-- BUILD THE IMAGE -->
## Build the image
If you wish, you can also build the image yourself.

```console
docker build -t enclaive/php-sgx:latest 'https://github.com/enclaive/enclaive-docker-php-sgx.git#master'
```

<!-- Import existing page -->
## Import existing page/Backup

**Important:** PHP-SGX runs in an enclave turning the application into an in-memory, fully encrypted process. Persistance is thus not guaranteed. Any changes made through the PHP admin interface are lost when the enclave is stopped. For production usage we strongly advise to take additional measures to keep track of changes, be it through a CI/CD pipeline or be it thorugh the in-build Akeeba backup plugin.

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**. If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- SUPPORT -->
## Support

Don't forget to give the project a star! Spread the word on social media! Thanks again!

<!-- LICENSE -->
## License

Distributed under the Apache License 2.0 License. See `LICENSE` for more information.

<!-- CONTACT -->
## Contact

enclaive.io - [@enclaive_io](https://twitter.com/enclaive_io) - contact@enclaive.io - [https://enclaive.io](https://enclaive.io)

<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

This project greatly celebrates all contributions from the open source community. Special shout out to [Dmitrii Kuvaiskii](https://github.com/dimakuv) from Intel/gramine project and the EdgelessDB team for their support. 

* [Gramine Project](https://github.com/gramineproject)
* [Intel SGX](https://github.com/intel/linux-sgx-driver)
* [PHP](https://github.com/php/php-src) 


## Trademarks 

This software listing is packaged by enclaive.io. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement. 
